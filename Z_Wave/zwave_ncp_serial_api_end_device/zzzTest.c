// /*
//  * Host API: Set Learn Mode (CmdID = 0x50)
//  * Handles host->module request and starts Z-Wave learn mode (inclusion/exclusion).
//  *
//  * Your Python host example frame:
//  *   01 05 00 50 81 02 29
//  *   SOF=01, LEN=05, TYPE=00(Request), CMD=50, INTENT=81, SESSION=02, CHK=29
//  *
//  * Notes:
//  * - This function accepts either:
//  *   A) FULL Host-API data frame starting with SOF (0x01), like the example above, OR
//  *   B) "Command payload only" [intent, session_id] (length=2), if your transport already stripped SOF/LEN/TYPE/CMD/CHK.
//  * - It validates checksum when a full frame is provided.
//  * - It immediately replies with a Response Data Frame "Status=OK" (per spec pattern).
//  * - Learn-mode progress is later reported via callback frames (STARTED / DONE / FAILED).
//  */

// #include <stdint.h>
// #include <stdbool.h>
// #include <string.h>

// #ifndef ARRAY_LEN
// #define ARRAY_LEN(a) (sizeof(a) / sizeof((a)[0]))
// #endif

// // -------------------------- Host API framing --------------------------

// enum {
//   HOSTAPI_SOF_DATA_FRAME = 0x01,
//   HOSTAPI_TYPE_REQUEST   = 0x00,
//   HOSTAPI_TYPE_RESPONSE  = 0x01,
// };

// enum {
//   HOSTAPI_CMD_SET_LEARN_MODE = 0x50,
// };

// // Typical/seen encodings for Learn Mode Intent.
// // (Exact values depend on Host API version; keep it tolerant.)
// typedef enum {
//   LEARN_INTENT_DISABLE   = 0x80, // commonly used in Host APIs
//   LEARN_INTENT_INCLUSION = 0x81,
//   LEARN_INTENT_EXCLUSION = 0x82,

//   // Also accept simpler forms some hosts use:
//   LEARN_INTENT_INCLUSION_ALT = 0x01,
//   LEARN_INTENT_EXCLUSION_ALT = 0x02,
// } learn_intent_t;

// // Z-Wave Learn Mode statuses for callback to host (example-friendly).
// typedef enum {
//   LEARN_CB_STARTED = 0x01,
//   LEARN_CB_DONE    = 0x06,
//   LEARN_CB_FAILED  = 0x07,
// } learn_cb_status_t;

// // -------------------------- Platform hooks (YOU wire these) --------------------------

// // Send raw bytes to host over UART/USB.
// static void hostapi_tx(const uint8_t *buf, uint8_t len);

// // Start Z-Wave learn mode in your stack (SoC: calls stack directly; NCP: calls into protocol).
// // Return true if accepted/started by stack.
// typedef enum {
//   ZW_LEARNMODE_DISABLE   = 0,
//   ZW_LEARNMODE_INCLUSION = 1,
//   ZW_LEARNMODE_EXCLUSION = 2,
// } zw_learn_mode_t;

// typedef struct {
//   uint8_t status; // started/done/failed...
//   uint8_t node_id;
// } zw_learn_info_t;

// static bool zw_stack_set_learn_mode(zw_learn_mode_t mode, void (*cb)(const zw_learn_info_t *info));

// // Get current NodeID (optional; used for callbacks if stack doesn't supply node id).
// static uint8_t zw_stack_get_node_id(void);

// // -------------------------- Internal state --------------------------

// static uint8_t g_learn_session_id = 0;

// // Host API checksum: 0xFF XOR Length XOR Type XOR CmdID XOR payload...
// static uint8_t hostapi_checksum_xor(uint8_t length, const uint8_t *type_cmd_payload, uint8_t type_cmd_payload_len)
// {
//   uint8_t c = 0xFF ^ length;
//   for (uint8_t i = 0; i < type_cmd_payload_len; i++) {
//     c ^= type_cmd_payload[i];
//   }
//   return c;
// }

// static void hostapi_send_set_learn_mode_response(uint8_t status, uint8_t session_id)
// {
//   // Response Data Frame format (same framing):
//   // SOF(01) LEN TYPE(01) CMD(50) STATUS SESSION CHK
//   // LEN counts: TYPE + CMD + payload(STATUS,SESSION) => 1+1+2 = 4
//   uint8_t frm[7];
//   const uint8_t len = 4;

//   frm[0] = HOSTAPI_SOF_DATA_FRAME;
//   frm[1] = len;
//   frm[2] = HOSTAPI_TYPE_RESPONSE;
//   frm[3] = HOSTAPI_CMD_SET_LEARN_MODE;
//   frm[4] = status;      // 1=OK, 0=FAIL (convention)
//   frm[5] = session_id;  // echo session for host correlation
//   frm[6] = hostapi_checksum_xor(len, &frm[2], /*TYPE..payload*/ (uint8_t)(len));

//   hostapi_tx(frm, (uint8_t)sizeof(frm));
// }

// static void hostapi_send_set_learn_mode_callback(learn_cb_status_t learn_status, uint8_t node_id, uint8_t session_id)
// {
//   // Callback frame is also a "Request" type from module->host per many Host API specs.
//   // SOF LEN TYPE(00) CMD(50) LEARN_STATUS NODEID SESSION CHK
//   // LEN = TYPE + CMD + payload(3) => 1+1+3 = 5
//   uint8_t frm[8];
//   const uint8_t len = 5;

//   frm[0] = HOSTAPI_SOF_DATA_FRAME;
//   frm[1] = len;
//   frm[2] = HOSTAPI_TYPE_REQUEST;          // callbacks use Request type (per spec excerpt)
//   frm[3] = HOSTAPI_CMD_SET_LEARN_MODE;
//   frm[4] = (uint8_t)learn_status;
//   frm[5] = node_id;
//   frm[6] = session_id;
//   frm[7] = hostapi_checksum_xor(len, &frm[2], len);

//   hostapi_tx(frm, (uint8_t)sizeof(frm));
// }

// static zw_learn_mode_t map_intent_to_zw_mode(uint8_t intent)
// {
//   switch (intent) {
//     case LEARN_INTENT_INCLUSION:
//     case LEARN_INTENT_INCLUSION_ALT:
//       return ZW_LEARNMODE_INCLUSION;

//     case LEARN_INTENT_EXCLUSION:
//     case LEARN_INTENT_EXCLUSION_ALT:
//       return ZW_LEARNMODE_EXCLUSION;

//     case LEARN_INTENT_DISABLE:
//     default:
//       return ZW_LEARNMODE_DISABLE;
//   }
// }

// static void learn_mode_stack_cb(const zw_learn_info_t *info)
// {
//   if (!info) return;

//   const uint8_t node_id = (info->node_id != 0) ? info->node_id : zw_stack_get_node_id();

//   switch (info->status) {
//     case LEARN_CB_STARTED:
//       hostapi_send_set_learn_mode_callback(LEARN_CB_STARTED, node_id, g_learn_session_id);
//       break;
//     case LEARN_CB_DONE:
//       hostapi_send_set_learn_mode_callback(LEARN_CB_DONE, node_id, g_learn_session_id);
//       break;
//     default:
//       hostapi_send_set_learn_mode_callback(LEARN_CB_FAILED, node_id, g_learn_session_id);
//       break;
//   }
// }

// /*
//  * Your requested function.
//  * Return:
//  * - true  : frame accepted and learn mode started/changed (or disable applied)
//  * - false : invalid frame / checksum / unsupported format
//  */
// static bool cmd_zw_set_learn_mode(const uint8_t *payload, uint8_t payload_len)
// {
//   if (!payload || payload_len == 0) {
//     return false;
//   }

//   uint8_t intent = 0;
//   uint8_t session_id = 0;

//   // --------------------------
//   // Case A: FULL Host API Data Frame (starts with SOF=0x01)
//   // --------------------------
//   if (payload[0] == HOSTAPI_SOF_DATA_FRAME) {
//     // Minimal full frame: SOF LEN TYPE CMD INTENT SESSION CHK  => 7 bytes
//     if (payload_len < 7) {
//       return false;
//     }

//     const uint8_t len = payload[1];   // counts TYPE..payload
//     const uint8_t type = payload[2];
//     const uint8_t cmd  = payload[3];

//     if (type != HOSTAPI_TYPE_REQUEST) {
//       return false;
//     }
//     if (cmd != HOSTAPI_CMD_SET_LEARN_MODE) {
//       return false;
//     }

//     // Validate length vs provided bytes:
//     // Total bytes = SOF(1) + LEN(1) + (TYPE..payload = len bytes) + CHK(1)
//     const uint8_t total = (uint8_t)(1 + 1 + len + 1);
//     if (payload_len < total) {
//       return false;
//     }

//     const uint8_t rx_chk = payload[total - 1];
//     const uint8_t calc_chk = hostapi_checksum_xor(len, &payload[2], len);
//     if (rx_chk != calc_chk) {
//       // Optional: send a NAK frame here if your Host API transport supports it.
//       hostapi_send_set_learn_mode_response(/*status=*/0x00, /*session_id=*/0x00);
//       return false;
//     }

//     // For Set Learn Mode initial request, payload is expected at least 2 bytes:
//     // [intent, session_id]
//     if (len < 4 /* TYPE+CMD + 2 payload */) {
//       hostapi_send_set_learn_mode_response(/*status=*/0x00, /*session_id=*/0x00);
//       return false;
//     }

//     intent     = payload[4];
//     session_id = payload[5];
//   }
//   // --------------------------
//   // Case B: Command payload only: [intent, session_id]
//   // --------------------------
//   else {
//     if (payload_len < 2) {
//       return false;
//     }
//     intent     = payload[0];
//     session_id = payload[1];
//   }

//   // Map intent to stack learn mode
//   const zw_learn_mode_t mode = map_intent_to_zw_mode(intent);

//   // Store session for callbacks (so host can correlate)
//   g_learn_session_id = session_id;

//   // Immediate response: "OK" means we accepted the command (not that inclusion finished).
//   hostapi_send_set_learn_mode_response(/*status=*/0x01, session_id);

//   // Start/stop learn mode in the stack
//   const bool ok = zw_stack_set_learn_mode(mode, learn_mode_stack_cb);

//   // If the stack rejects, you may choose to send an additional response or a FAILED callback.
//   if (!ok) {
//     hostapi_send_set_learn_mode_callback(LEARN_CB_FAILED, zw_stack_get_node_id(), session_id);
//     return false;
//   }

//   return true;
// }

// // -------------------------- Example stubs (replace with your platform) --------------------------

// static void hostapi_tx(const uint8_t *buf, uint8_t len)
// {
//   (void)buf; (void)len;
//   // TODO: Implement UART/USB write for your platform.
//   // e.g., uart_write(buf, len);
// }

// static bool zw_stack_set_learn_mode(zw_learn_mode_t mode, void (*cb)(const zw_learn_info_t *info))
// {
//   (void)mode; (void)cb;
//   // TODO: Call your actual Z-Wave stack API here.
//   // SoC example (conceptual):
//   //   return (ZW_SetLearnMode(mode_enum, internal_cb_adapter) == SUCCESS);
//   // NCP example:
//   //   return zwapi_set_learn_mode(mode) ...; (the stack is local in NCP firmware)
//   return true;
// }

// static uint8_t zw_stack_get_node_id(void)
// {
//   // TODO: Return NodeID from stack/NVM if available.
//   return 0;
// }
