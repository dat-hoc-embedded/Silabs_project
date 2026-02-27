// #include <stdint.h>
// #include <stdbool.h>

// #define HOST_SOF                 0x01
// #define HOST_TYPE_REQUEST        0x00
// #define HOST_TYPE_RESPONSE       0x01
// #define HOST_CMD_SET_LEARN_MODE  0x50

// // ---- Bạn tự nối vào UART/USB TX ----
// static void host_tx_bytes(const uint8_t *buf, uint8_t len);

// // XOR checksum theo Host API (thường dạng: 0xFF XOR Length XOR Type..Payload)
// static uint8_t host_checksum(uint8_t length, const uint8_t *type_to_payload, uint8_t n)
// {
//   uint8_t c = (uint8_t)(0xFF ^ length);
//   for (uint8_t i = 0; i < n; i++) c ^= type_to_payload[i];
//   return c;
// }

// static void  host_send_set_learn_mode_response(uint8_t status, uint8_t session_id)
// {
//   // Response frame: SOF LEN TYPE CMD STATUS SESSION CHK
//   // LEN = TYPE(1) + CMD(1) + payload(STATUS,SESSION=2) = 4
//   uint8_t frm[7];
//   frm[0] = HOST_SOF;
//   frm[1] = 4;
//   frm[2] = HOST_TYPE_RESPONSE;
//   frm[3] = HOST_CMD_SET_LEARN_MODE;
//   frm[4] = status;      // 1=OK, 0=FAIL (convention)
//   frm[5] = session_id;
//   frm[6] = host_checksum(frm[1], &frm[2], frm[1]);
//   host_tx_bytes(frm, (uint8_t)sizeof(frm));
// }

// // ===================== Learn mode bridge =====================
// // Nếu là SoC + ZAF:
// typedef enum {
//   E_NETWORK_LEARN_MODE_ACTION_STOP = 0,
//   E_NETWORK_LEARN_MODE_ACTION_START_INCLUSION,
//   E_NETWORK_LEARN_MODE_ACTION_START_EXCLUSION,
// } E_NETWORK_LEARN_MODE_ACTION;

// // Có trong ZAF:
// extern void ZAF_setNetworkLearnMode(E_NETWORK_LEARN_MODE_ACTION bMode);

// // Nếu là NCP Serial API (tuỳ SDK, tên enum có thể khác):
// typedef enum {
//   LEARN_MODE_DISABLE   = 0,
//   LEARN_MODE_INCLUSION = 1,
//   LEARN_MODE_EXCLUSION = 2,
// } learn_mode_t;

// // Ví dụ signature; trong NCP bạn sẽ gọi vào stack/serialapi core:
// extern uint8_t ZW_SetLearnMode(learn_mode_t mode /*, callback...*/);

// // ===================== Handler chính =====================
// static bool cmd_zw_set_learn_mode(const uint8_t *payload, uint8_t payload_len)
// {
//   // Frame tối thiểu: SOF LEN TYPE CMD INTENT SESSION CHK = 7 bytes
//   if (!payload || payload_len < 7) return false;

//   if (payload[0] != HOST_SOF) return false;

//   const uint8_t len  = payload[1];
//   const uint8_t type = payload[2];
//   const uint8_t cmd  = payload[3];

//   if (type != HOST_TYPE_REQUEST) return false;
//   if (cmd  != HOST_CMD_SET_LEARN_MODE) return false;

//   const uint8_t total = (uint8_t)(1 /*SOF*/ + 1 /*LEN*/ + len + 1 /*CHK*/);
//   if (payload_len < total) return false;

//   const uint8_t rx_chk   = payload[total - 1];
//   const uint8_t calc_chk = host_checksum(len, &payload[2], len);
//   if (rx_chk != calc_chk) {
//     host_send_set_learn_mode_response(0x00, 0x00);
//     return false;
//   }

//   // Với Set Learn Mode, payload thường có ít nhất 2 byte: intent, session
//   // (LEN = TYPE + CMD + 2 = 4)
//   if (len < 4) {
//     host_send_set_learn_mode_response(0x00, 0x00);
//     return false;
//   }

//   const uint8_t intent     = payload[4];
//   const uint8_t session_id = payload[5];

//   // ✅ trả OK ngay: "đã nhận lệnh" (chưa phải include xong)
//   host_send_set_learn_mode_response(0x01, session_id);

//   // ---- Parse intent kiểu bitfield (tolerant) ----
//   // Thường bit7=1 nghĩa là START; phần thấp là action/flags.
//   const bool start = (intent & 0x80) != 0;
//   const uint8_t sub = (uint8_t)(intent & 0x0F); // phần thấp (action/flags)

//   if (!start) {
//     // nếu host muốn stop bằng kiểu khác, bạn có thể handle ở đây
//     // (hoặc treat start=0 => STOP)
//     ZAF_setNetworkLearnMode(E_NETWORK_LEARN_MODE_ACTION_STOP);
//     return true;
//   }

//   // Map sub-action (bạn nên đối chiếu spec để map chính xác)
//   // Mình map các case phổ biến và để "unknown" fail rõ ràng.
//   if (sub == 0x01) {
//     // Inclusion (classic)
//     ZAF_setNetworkLearnMode(E_NETWORK_LEARN_MODE_ACTION_START_INCLUSION);
//     return true;
//   } else if (sub == 0x02) {
//     // Exclusion
//     ZAF_setNetworkLearnMode(E_NETWORK_LEARN_MODE_ACTION_START_EXCLUSION);
//     return true;
//   } else if (sub == 0x04) {
//     // Ở frame của bạn: 0x84 => start + sub=0x04
//     // sub=0x04 có thể là "LR inclusion" hoặc "option flag" tuỳ Host API version.
//     // Nếu bạn muốn coi nó là LR inclusion, thì vẫn start inclusion,
//     // nhưng đảm bảo device đã bật region *_LR (phần 4 bên dưới).
//     ZAF_setNetworkLearnMode(E_NETWORK_LEARN_MODE_ACTION_START_INCLUSION);
//     return true;
//   } else {
//     // Unsupported intent/flag
//     // Bạn có thể gửi callback FAILED ở đây nếu hệ thống bạn có callback frame.
//     return false;
//   }
// }

// // ---- Stub TX ----
// static void host_tx_bytes(const uint8_t *buf, uint8_t len)
// {
//   (void)buf; (void)len;
//   // TODO: uart_write(buf, len);
// }


#include <stdint.h>
#include <stdbool.h>

// ---------------- Host API constants ----------------
enum {
  HOST_SOF                = 0x01,
  HOST_TYPE_REQUEST       = 0x00,   // callbacks MUST use Request type (the spec you pasted)
  HOST_CMD_SET_LEARN_MODE = 0x50,
};

// Learn Mode Status (Table 4.80)
typedef enum {
  LEARN_STATUS_STARTED   = 0x01,
  LEARN_STATUS_COMPLETED = 0x06,
  LEARN_STATUS_FAILED    = 0x07,
} learn_mode_status_t;

// NodeID base type (configured via Z-Wave API Setup "Set NodeID Base Type")
typedef enum {
  NODEID_BASE_8BIT  = 0,
  NODEID_BASE_16BIT = 1,
} nodeid_base_type_t;

// ---------------- You must implement these hooks ----------------

// Send bytes to host over UART/USB
static void host_tx_bytes(const uint8_t *buf, uint8_t len);

// Get current NodeID base type (8-bit or 16-bit) from your module configuration
// - In a real NCP/Host-API module, this is whatever the host configured via "Z-Wave API Setup".
// - In many products: classic=8-bit; LR deployments may set 16-bit.
static nodeid_base_type_t zw_get_nodeid_base_type(void);

// Get current NodeID as 16-bit (works for both classic & LR: classic fits in 0..255)
// - Best source is the learn callback info if available; this is fallback.
static uint16_t zw_get_node_id_u16(void);

// ---------------- Helper: checksum ----------------
// Checksum = 0xFF XOR Length XOR Type XOR CmdID XOR payload...
static uint8_t hostapi_checksum(uint8_t length, const uint8_t *type_to_payload, uint8_t n)
{
  uint8_t c = (uint8_t)(0xFF ^ length);
  for (uint8_t i = 0; i < n; i++) c ^= type_to_payload[i];
  return c;
}

// ---------------- Build + send Set Learn Mode Callback frame ----------------
//
// Frame (Data frame format):
//   SOF(0x01)
//   LEN = bytes(Type..Payload)  (NOT include SOF nor checksum)
//   TYPE = 0x00 (Request for callbacks)
//   CMD  = 0x50
//   Payload:
//     session_id (1 byte)
//     learn_status (1 byte)
//     nodeid (1 or 2 bytes depending on base type)
//   CHK  = XOR checksum
//
static void hostapi_send_set_learn_mode_callback(uint8_t session_id,
                                                 learn_mode_status_t status,
                                                 uint16_t node_id_u16)
{
  const nodeid_base_type_t base = zw_get_nodeid_base_type();

  uint8_t frm[9];               // max size: SOF+LEN+TYPE+CMD+session+status+nodeid(2)+CHK = 9
  uint8_t idx = 0;

  frm[idx++] = HOST_SOF;

  // Reserve LEN position; fill later
  const uint8_t len_pos = idx++;
  frm[idx++] = HOST_TYPE_REQUEST;
  frm[idx++] = HOST_CMD_SET_LEARN_MODE;

  frm[idx++] = session_id;
  frm[idx++] = (uint8_t)status;

  if (base == NODEID_BASE_16BIT) {
    // Encode NodeID as 16-bit (big-endian is typical for protocol tables; confirm your spec section if it states endianness)
    frm[idx++] = (uint8_t)((node_id_u16 >> 8) & 0xFF);
    frm[idx++] = (uint8_t)(node_id_u16 & 0xFF);
  } else {
    // 8-bit node id
    frm[idx++] = (uint8_t)(node_id_u16 & 0xFF);
  }

  // LEN counts: TYPE..payload bytes
  const uint8_t len = (uint8_t)((idx - 2) /*exclude SOF+LEN*/);
  frm[len_pos] = len;

  // checksum over: LEN + TYPE..payload
  const uint8_t chk = hostapi_checksum(len, &frm[2], len);
  frm[idx++] = chk;

  host_tx_bytes(frm, idx);
}