/*******************************************************************************
 * @file
 * @brief Core application logic.
 *******************************************************************************
 * # License
 * <b>Copyright 2024 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * SPDX-License-Identifier: Zlib
 *
 * The licensor of this software is Silicon Laboratories Inc.
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 *
 ******************************************************************************/

// Define module name for Power Manager debuging feature.
#define CURRENT_MODULE_NAME "OPENTHREAD_SAMPLE_APP"

#include <assert.h>
#include <openthread-core-config.h>
#include <openthread/config.h>

#include <openthread/cli.h>
#include <openthread/diag.h>
#include <openthread/tasklet.h>

#include "app.h"
#include "openthread-system.h"

#include "reset_util.h"

#include "sl_component_catalog.h"
#include "sl_memory_manager.h"
#ifdef SL_CATALOG_POWER_MANAGER_PRESENT
#include "sl_power_manager.h"
#endif

#ifdef SL_CATALOG_KERNEL_PRESENT
#include "sl_ot_rtos_adaptation.h"
#endif // SL_CATALOG_KERNEL_PRESENT

#if (defined(SL_CATALOG_BTN0_PRESENT) || defined(SL_CATALOG_BTN1_PRESENT))
#include "sl_button.h"
#include "sl_simple_button.h"
#endif


#include "openthread/dataset.h" // include dataset.h for otDatasetSetActive
#include "openthread/thread.h" // include thread.h for otThreadSetEnabled 

// my_library includes
#include <string.h> // include library for memcpy
#include "stdio.h"
#include <stdarg.h>
#include "openthread/udp.h" // for otUdpSetReceiveCallback
#include "openthread/ip6.h" // for otIp6SetEnabled

#include "openthread/srp_client.h" // for SRP Client
#include "openthread/srp_client_buffers.h" // for SRP Client Buffers
#include "openthread/dnssd_server.h" // for DNS-SD Server

#include "autogen/sl_iostream_init_eusart_instances.h"

#include "app_udp_led.h" // include LED header for UDP LED toggle

/**
 * This function initializes the CLI app.
 * 
 * @param[in]  aInstance  The OpenThread instance structure.
 * 
 */
extern void otAppCliInit(otInstance *aInstance);

#if OPENTHREAD_CONFIG_MULTIPLE_INSTANCE_ENABLE
static uint8_t *sOtInstanceBuffer = NULL;
#endif
static otInstance *sInstance      = NULL;
static bool        sButtonPressed = false;
static bool        sStayAwake     = true;

// SRP Client variables
static bool sSrpClientEnabled = false;

otInstance *otGetInstance(void)
{
    return sInstance;
}

#if (defined(SL_CATALOG_BTN0_PRESENT) || defined(SL_CATALOG_BTN1_PRESENT))
void sl_button_on_change(const sl_button_t *handle)
{
    if (sl_button_get_state(handle) == SL_SIMPLE_BUTTON_PRESSED)
    {
        sButtonPressed = true;
#ifdef SL_CATALOG_KERNEL_PRESENT
        sl_ot_rtos_set_pending_event(SL_OT_RTOS_EVENT_APP);
#endif
        otSysEventSignalPending();
    }
}
#endif

void sl_ot_rtos_application_tick(void)
{
    if (sButtonPressed)
    {
        sButtonPressed = false;
        sStayAwake     = !sStayAwake;
        if (sStayAwake)
        {
#ifdef SL_CATALOG_POWER_MANAGER_PRESENT
            sl_power_manager_add_em_requirement(SL_POWER_MANAGER_EM1);
#endif
        }
        else
        {
#ifdef SL_CATALOG_POWER_MANAGER_PRESENT
            sl_power_manager_remove_em_requirement(SL_POWER_MANAGER_EM1);
#endif
        }
    }
}

/*
 * Provide, if required an "otPlatLog()" function
 */
#if OPENTHREAD_CONFIG_LOG_OUTPUT == OPENTHREAD_CONFIG_LOG_OUTPUT_APP
void otPlatLog(otLogLevel aLogLevel, otLogRegion aLogRegion, const char *aFormat, ...)
{
    OT_UNUSED_VARIABLE(aLogLevel);
    OT_UNUSED_VARIABLE(aLogRegion);
    OT_UNUSED_VARIABLE(aFormat);

    va_list ap;
    va_start(ap, aFormat);
    otCliPlatLogv(aLogLevel, aLogRegion, aFormat, ap);
    va_end(ap);

}
#endif

void sl_ot_create_instance(void)
{
#if OPENTHREAD_CONFIG_MULTIPLE_INSTANCE_ENABLE
    size_t otInstanceBufferLength = 0;

    // Call to query the buffer size
    (void)otInstanceInit(NULL, &otInstanceBufferLength);

    // Call to allocate the buffer
    sOtInstanceBuffer = (uint8_t *)sl_malloc(otInstanceBufferLength);
    assert(sOtInstanceBuffer);

    // Initialize OpenThread with the buffer
    sInstance = otInstanceInit(sOtInstanceBuffer, &otInstanceBufferLength);
#else
    sInstance = otInstanceInitSingle();
#endif
    assert(sInstance);
}

void sl_ot_cli_init(void)
{
    otAppCliInit(sInstance);
}

/******************************************************************************
 * Application Init.
 *****************************************************************************/

void app_init(void)
{
    OT_SETUP_RESET_JUMP(argv);

    //led_init(); // Initialize LED

    set_active_dataset();
    Udp_led_init(sInstance, 3010);
    //udp_socket_init(sInstance, 3010); // Initialize UDP socket on local port 3010  -> for receiving messages 
    //udp_socket_init(sInstance, 3011); // Initialize UDP socket on local port 3011  -> for sending messages  
    

    // Enable SRP Client only if instance is available
    if (sInstance != NULL)
    {
        srp_client_enable(sInstance);

        // Register an example service
        // Example: Register HTTP service
        srp_client_register_service(sInstance, "_apptest._udp", "embeddat-device", 3010, "openthread-node");
        srp_client_register_service(sInstance, "_apptest._tcp", "embeddat2-device", 2602, "openthread-node");
    }
    else
    {
        printf("Warning: sInstance is NULL in app_init(), SRP init delayed\n");
    }
}

/******************************************************************************
 * Application Process Action.
 *****************************************************************************/
void app_process_action(void)
{
    otTaskletsProcess(sInstance);
    otSysProcessDrivers(sInstance);
   
    // Example: Send a UDP message once when device is attached

    static bool sent = true; // change send -> False to printf msg 
    if (!sent && otThreadGetDeviceRole(sInstance) != OT_DEVICE_ROLE_DISABLED && otThreadGetDeviceRole(sInstance) != OT_DEVICE_ROLE_DETACHED)
    {
        sent = true;
        const char msg[] = "Hello from OpenThread UDP Client!";
        const size_t msgLen = strlen(msg);
        otIp6Address destAddr;
        // Replace with actual OTBR mesh-local/global address (must match dataset prefix).
        otIp6AddressFromString("fd3a:b82a:8255:c2db:d328:43a8:b6d4:b780", &destAddr);
        otError error = udp_send_message(sInstance, &destAddr, 3011, (const uint8_t *)msg, (uint16_t)msgLen); // Send to port 3011
        if (error == OT_ERROR_NONE)
        {
            printf("UDP message sent successfully.\n"); 
        }
        else
        {
            printf("Failed to send UDP message. Error: %d\n", error);
        }
    }
}

/******************************************************************************
 * Application Exit.
 *****************************************************************************/
void app_exit(void)
{
    otInstanceFinalize(sInstance);
#if OPENTHREAD_CONFIG_MULTIPLE_INSTANCE_ENABLE
    sl_free(sOtInstanceBuffer);
#endif
    // TO DO : pseudo reset?
}

/**
 * @brief Set the active dataset object
 * @note Need include dataset.h and thread.h
 * 
 */
#define OT_PSKC_LENGTH 16
void set_active_dataset(void)
{
    otOperationalDataset dataset;   // Dataset structure
    otError               error;        // Return value for error checking

    memset(&dataset, 0, sizeof(dataset));  // Clear dataset structure

    static const uint8_t mNetworkKey[OT_NETWORK_KEY_SIZE] = {
        0xe3, 0x61, 0x95, 0x4b, 0xc2, 0x79, 0x56, 0x7c,
        0x3f, 0xbd, 0x88, 0xe2, 0x04, 0xa1, 0x1c, 0xc4,
    };
    static const uint8_t mExtPanId[OT_EXT_PAN_ID_SIZE] = {
        0x4e, 0x58, 0x54, 0xde, 0xab, 0x64, 0xd3, 0x3a,
    };
    static const uint8_t mMeshLocalPrefix [OT_MESH_LOCAL_PREFIX_SIZE] = {
        0xfd, 0x3a, 0xb8, 0x2a, 0x82, 0x55, 0xc2, 0xdb,
    };

    static const char mNetworkName[OT_NETWORK_NAME_MAX_SIZE + 1] = "OpenThread-13bd";
    static const uint8_t mChannel = 24;
    static const uint8_t  mCslChannel    = 22;          // Wake-up Channel
    static const uint32_t mChannelMask   = 0x07fff800;
    static const uint16_t mPanId         = 0x13bd;
    static const uint16_t mActiveSeconds = 1;           // Active Timestamp seconds
    static const uint16_t mSecurityRotation = 672;      // Security Policy rotation
    static const uint8_t  mPskc[OT_PSKC_LENGTH] = {
        0xb0, 0x03, 0xe2, 0x37, 0x7c, 0xf3, 0xf2, 0xbf,
        0xbb, 0xc4, 0xa1, 0xcc, 0x64, 0x35, 0xe7, 0xde,
    };  

    // Set Active Timestamp
    dataset.mActiveTimestamp.mSeconds = mActiveSeconds;
    dataset.mActiveTimestamp = (otTimestamp){
        .mSeconds = mActiveSeconds,
        .mTicks = 0,
        .mAuthoritative = true,
    };
    dataset.mComponents.mIsActiveTimestampPresent = true;

    memcpy (dataset.mNetworkKey.m8, mNetworkKey, OT_NETWORK_KEY_SIZE);
    dataset.mComponents.mIsNetworkKeyPresent = true;
    
    memcpy (dataset.mExtendedPanId.m8, mExtPanId, OT_EXT_PAN_ID_SIZE);
    dataset.mComponents.mIsExtendedPanIdPresent = true;
    
    memcpy (dataset.mMeshLocalPrefix.m8, mMeshLocalPrefix, OT_MESH_LOCAL_PREFIX_SIZE);
    dataset.mComponents.mIsMeshLocalPrefixPresent = true;

    memcpy (dataset.mNetworkName.m8, mNetworkName, sizeof(mNetworkName));
    dataset.mComponents.mIsNetworkNamePresent = true;

    dataset.mPanId = mPanId;
    dataset.mComponents.mIsPanIdPresent = true;

    dataset.mChannel = mChannel;
    dataset.mComponents.mIsChannelPresent = true;

    dataset.mChannelMask = mChannelMask;
    dataset.mComponents.mIsChannelMaskPresent = true;

    dataset.mWakeupChannel = mCslChannel;
    dataset.mComponents.mIsWakeupChannelPresent = true;

    memcpy(dataset.mPskc.m8, mPskc, sizeof(mPskc));
    dataset.mComponents.mIsPskcPresent = true;

    dataset.mSecurityPolicy.mRotationTime = mSecurityRotation;
    dataset.mComponents.mIsSecurityPolicyPresent = true;

    // Set the active dataset to the Thread stack 
    error = otDatasetSetActive(sInstance, &dataset);
    assert(error == OT_ERROR_NONE);

    otIp6SetEnabled(sInstance, true);
    otThreadSetEnabled(sInstance, true);
}

static otUdpSocket udpSocket;
void udp_socket_init(otInstance *aInstance, uint16_t localPort)
{

    otError error;

    memset(&udpSocket, 0, sizeof(udpSocket));

    error = otUdpOpen(aInstance, &udpSocket, NULL, NULL);
    assert(error == OT_ERROR_NONE);

    otSockAddr sockAddr;
    memset(&sockAddr, 0, sizeof(sockAddr));
    sockAddr.mPort = localPort;

    error = otUdpBind(aInstance, &udpSocket, &sockAddr, OT_NETIF_THREAD_HOST);
    assert(error == OT_ERROR_NONE);
    
}
otError udp_send_message(otInstance *aInstance, const otIp6Address *destAddr, uint16_t destPort, const uint8_t *data, uint16_t dataLen)
{
    otError error;

    otMessage *message = otUdpNewMessage(aInstance, NULL); // Create Null buffer message for Thread instance  
    if (message == NULL)
    {
        return OT_ERROR_NO_BUFS;
    }

    error = otMessageAppend(message, data, dataLen); // Append data to message
    if (error != OT_ERROR_NONE)
    {
        otMessageFree(message);
        return error;
    }

    // otSockAddr peerAddr;
    // memset(&peerAddr, 0, sizeof(peerAddr));
    // peerAddr.mAddress = *destAddr;
    // peerAddr.mPort = destPort;

    // error = otUdpConnect(aInstance, &udpSocket, &peerAddr);
    // if (error != OT_ERROR_NONE)
    // {
    //     otMessageFree(message);
    //     return error;
    // }

    otMessageInfo messageInfo;
    memset(&messageInfo, 0, sizeof(messageInfo));
    messageInfo.mPeerAddr = *destAddr;
    messageInfo.mPeerPort = destPort;

    error = otUdpSend(aInstance, &udpSocket, message, &messageInfo); // Send message via UDP socket 
    if (error != OT_ERROR_NONE)
    {
        otMessageFree(message);
        return error;
    }

    return OT_ERROR_NONE;
}
/******************************************************************************
 * SRP Client Functions.
 *****************************************************************************/

/* Note: Buffer management uses the SRP client buffers API (otSrpClientBuffersAllocateService())
   We allocate a service entry when registering a service. No global buffer init required here. */

/**
 * @brief SRP Client callback function
 * @param[in] aError    The error code
 * @param[in] aInstance The OpenThread instance
 * 
 */
static void srp_client_callback(otError aError,
                                const otSrpClientHostInfo *aHostInfo,
                                const otSrpClientService *aServices,
                                const otSrpClientService *aRemovedServices,
                                void *aContext)
{
    OT_UNUSED_VARIABLE(aHostInfo);
    OT_UNUSED_VARIABLE(aServices);
    OT_UNUSED_VARIABLE(aRemovedServices);
    OT_UNUSED_VARIABLE(aContext);

    if (aError == OT_ERROR_NONE)
    {
        printf("SRP Client callback: Update succeeded\n");
    }
    else
    {
        printf("SRP Client callback: Error %d\n", aError);
    }
}

/**
 * @brief Register a service with SRP Client
 * @param[in] aInstance         The OpenThread instance
 * @param[in] aServiceName      The service name (e.g., "_http._tcp")
 * @param[in] aInstanceName     The service instance name (e.g., "MyService")
 * @param[in] aPort             The service port number
 * @param[in] aHostName         The host name (e.g., "myhost")
 * 
 */
otError srp_client_register_service(otInstance *aInstance, 
                                     const char *aServiceName,
                                     const char *aInstanceName,
                                     uint16_t aPort,
                                     const char *aHostName)
{
    if (aInstance == NULL)
    {
        printf("srp_client_register_service: aInstance is NULL\n");
        return OT_ERROR_INVALID_ARGS;
    }
    otError error = OT_ERROR_NONE;
    otSrpClientBuffersServiceEntry *entry = NULL;
    static otSrpClientService sService; // fallback persistent service instance

    // Use SRP client buffer allocator to get a service entry if available
    entry = otSrpClientBuffersAllocateService(aInstance);

    // if allocated successfully, fill and add the service
    if (entry != NULL)
    {
        // Fill fields in the allocated entry's service
        entry->mService.mName = aServiceName;
        entry->mService.mInstanceName = aInstanceName;
        entry->mService.mPort = aPort;
        entry->mService.mPriority = 0;
        entry->mService.mWeight = 0;
        entry->mService.mNumTxtEntries = 0;

        // Ensure host name and addresses are set (enable auto host addresses)
        (void)otSrpClientEnableAutoHostAddress(aInstance);
        (void)otSrpClientSetHostName(aInstance, aHostName);

        error = otSrpClientAddService(aInstance, &entry->mService);
        if (error != OT_ERROR_NONE)
        {
            printf("otSrpClientAddService() failed: %d\n", error);
            otSrpClientBuffersFreeService(aInstance, entry);
            return error;
        }

        printf("SRP service registered: %s.%s on port %d\n", aInstanceName, aServiceName, aPort); 
        return OT_ERROR_NONE;
    }

    // Fallback: use a static service structure (must persist)
    memset(&sService, 0, sizeof(sService));
    sService.mName = aServiceName;
    sService.mInstanceName = aInstanceName;
    sService.mPort = aPort;

    (void)otSrpClientEnableAutoHostAddress(aInstance);
    (void)otSrpClientSetHostName(aInstance, aHostName);

    error = otSrpClientAddService(aInstance, &sService);
    if (error != OT_ERROR_NONE)
    {
        printf("otSrpClientAddService() failed (fallback): %d\n", error);
        return error;
    }

    printf("SRP service registered (fallback): %s.%s on port %d\n", aInstanceName, aServiceName, aPort);
    return OT_ERROR_NONE;
}

/**
 * @brief Enable SRP Client
 * @param[in] aInstance The OpenThread instance
 * 
 */
void srp_client_enable(otInstance *aInstance)
{
    //otError error;

    if (sSrpClientEnabled)
    {
        printf("SRP Client already enabled\n");
        return;
    }
    if (aInstance == NULL)
    {
        printf("srp_client_enable: aInstance is NULL\n");
        return;
    }
    // Set SRP Client callback
    otSrpClientSetCallback(aInstance, srp_client_callback, NULL);

    // Ensure host info is configured before starting client
    {
        const otSrpClientHostInfo *hostInfo = otSrpClientGetHostInfo(aInstance);
        if (hostInfo == NULL || hostInfo->mName == NULL)
        {
            // Enable auto host addresses and set a default host name
            (void)otSrpClientEnableAutoHostAddress(aInstance);
            (void)otSrpClientSetHostName(aInstance, "openthread-node-enable");
        }
    }

    // Start SRP Client
    // error = otSrpClientStart(aInstance, NULL);
    // if (error != OT_ERROR_NONE)
    // {
    //     printf("Failed to start SRP Client. Error: %d\n", error);
    //     return;
    // }

    // sSrpClientEnabled = true;
    // printf("SRP Client enabled successfully\n");
}

/**
 * @brief Disable SRP Client
 * @param[in] aInstance The OpenThread instance
 * 
 */
void srp_client_disable(otInstance *aInstance)
{
    otError error;

    if (!sSrpClientEnabled)
    {
        printf("SRP Client already disabled\n");
        return;
    }

    if (aInstance == NULL)
    {
        printf("srp_client_disable: aInstance is NULL\n");
        return;
    }

    otSrpClientStop(aInstance);
    if (error != OT_ERROR_NONE)
    {
        return;
        printf("Failed to stop SRP Client. Error: %d\n", error);
    }

    sSrpClientEnabled = false;
    printf("SRP Client disabled successfully\n");
}
