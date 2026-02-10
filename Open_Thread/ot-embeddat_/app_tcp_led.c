/**
 * @file app_tcp_led.c
 * @author Embeddat (embeddat.dev@gmail.com)
 * @brief
 * @version 0.1
 * @date 2025-12-29
 *
 * @copyright Copyright (c) 2025
 *
 */
#include "app_tcp_led.h"

#include <stdlib.h>

#define APP_TCP_RX_LINE_MAX 128

typedef struct TcpTxBuffer
{
    otLinkedBuffer mLink;
    char           mData[];
} TcpTxBuffer;

static otTcpListener sListener;  ///< port listion 
static otTcpEndpoint sEndpoint;  ///< connect TCP after accepting
static uint8_t       sReceiveBuffer[OT_TCP_RECEIVE_BUFFER_SIZE_FEW_HOPS]; // OT TCP use bufer to save data
static char          sRxLine[APP_TCP_RX_LINE_MAX]; ///< 
static size_t        sRxLineLen;

static void TcpSendString(otTcpEndpoint *aEp, const char *aStr)
{
    size_t len = strlen(aStr);
    TcpTxBuffer *tx = (TcpTxBuffer *)malloc(sizeof(*tx) + len);
    if (tx == NULL)
    {
        return;
    }

    tx->mLink.mNext = NULL;
    tx->mLink.mData = (const uint8_t *)tx->mData;
    tx->mLink.mLength = len;
    memcpy(tx->mData, aStr, len);

    if (otTcpSendByReference(aEp, &tx->mLink, 0) != OT_ERROR_NONE)
    {
        free(tx);
    }
}

static void HandleLedCommand(const char *cmd)
{
    if (strcmp(cmd, "led on") == 0)
    {
        sl_led_turn_on(&sl_led_led0);
        printf("LED0 ON");
    }
    else if (strcmp(cmd, "led off") == 0)
    {
        sl_led_turn_off(&sl_led_led0);
        printf("LED0 OFF");
    }
    else if (strcmp(cmd, "led toggle") == 0)
    {
        sl_led_toggle(&sl_led_led0);
        printf("LED0 TOGGLE");
    }
    else
    {
        printf("Unknown cmd: '%s'", cmd);
    }
}

static void NormalizeLine(char *buf)
{
    size_t n = strlen(buf);
    while (n > 0 && (buf[n - 1] == '\n' || buf[n - 1] == '\r' || buf[n - 1] == ' ' || buf[n - 1] == '\t'))
    {
        buf[n - 1] = '\0';
        n--;
    }
}

static void ProcessRxLine(otTcpEndpoint *aEndpoint)
{
    sRxLine[sRxLineLen] = '\0';
    NormalizeLine(sRxLine);
    if (sRxLine[0] == '\0')
    {
        sRxLineLen = 0;
        return;
    }

    printf("TCP RX cmd: '%s'", sRxLine);
    HandleLedCommand(sRxLine);
    TcpSendString(aEndpoint, "ok\n");
    sRxLineLen = 0;
}
/**
 * @brief 
 * 
 * @param aEndpoint 
 * @param aData 
 */
static void HandleTcpSendDone(otTcpEndpoint *aEndpoint, otLinkedBuffer *aData)
{
    OT_UNUSED_VARIABLE(aEndpoint);

    if (aData != NULL)
    {
        free(aData);
    }
}

/**
 * @brief Receive data
 * 
 * @param aEndpoint 
 * @param aBytesAvailable : the number of bytes is waiting
 * @param aEndOfStream : đóng TCP (FIN)
 * @param aBytesRemaining 
 */
static void HandleTcpReceiveAvailable(otTcpEndpoint *aEndpoint,
                                      size_t         aBytesAvailable,
                                      bool           aEndOfStream,
                                      size_t         aBytesRemaining)
{
    OT_UNUSED_VARIABLE(aBytesRemaining);

    if (aBytesAvailable == 0)
    {
        if (aEndOfStream && sRxLineLen > 0)
        {
            ProcessRxLine(aEndpoint);
        }
        return;
    }

    const otLinkedBuffer *rx = NULL;
    otError               err = otTcpReceiveByReference(aEndpoint, &rx);

    if (err != OT_ERROR_NONE || rx == NULL)
    {
        printf("TCP receive error: %d", err);
        return;
    }

    size_t bytesToConsume = 0;
    bool   lineComplete = false;

    while (rx != NULL)
    {
        size_t space = (sizeof(sRxLine) - 1) - sRxLineLen;
        if (space == 0)
        {
            ProcessRxLine(aEndpoint);
            space = (sizeof(sRxLine) - 1) - sRxLineLen;
        }

        size_t take = rx->mLength;
        if (take > space)
        {
            take = space;
        }

        if (take == 0)
        {
            break;
        }

        const uint8_t *data = rx->mData;
        const uint8_t *nl = memchr(data, '\n', take);
        if (nl != NULL)
        {
            take = (size_t)(nl - data) + 1;
            lineComplete = true;
        }

        memcpy(&sRxLine[sRxLineLen], data, take);
        sRxLineLen += take;
        bytesToConsume += take;

        if (lineComplete)
        {
            break;
        }

        rx = rx->mNext;
    }

    if (bytesToConsume > 0)
    {
        (void)otTcpCommitReceive(aEndpoint, bytesToConsume, 0);
    }

    if (lineComplete || (aEndOfStream && sRxLineLen > 0) || sRxLineLen == (sizeof(sRxLine) - 1))
    {
        ProcessRxLine(aEndpoint);
    }
}

static void HandleTcpDisconnected(otTcpEndpoint *aEndpoint, otTcpDisconnectedReason aReason)
{
    OT_UNUSED_VARIABLE(aEndpoint);

    sRxLineLen = 0;
    printf("TCP disconnected, reason=%d", aReason);
}

/**
 * @brief Send "ready" to client to inform server ready
 * 
 * @param aEndpoint 
 */
static void HandleTcpEstablished(otTcpEndpoint *aEndpoint)
{
    const otSockAddr *peer = otTcpGetPeerAddress(aEndpoint);
    if (peer != NULL)
    {
        char ipStr[OT_IP6_ADDRESS_STRING_SIZE];
        otIp6AddressToString(&peer->mAddress, ipStr, sizeof(ipStr));
        printf("TCP connected from [%s]:%u", ipStr, peer->mPort);
    }

    TcpSendString(aEndpoint, "ready\n");
}

static otTcpIncomingConnectionAction HandleTcpAcceptReady(otTcpListener    *aListener,
                                                          const otSockAddr *aPeer,
                                                          otTcpEndpoint   **aAcceptInto)
{
    OT_UNUSED_VARIABLE(aListener);
    OT_UNUSED_VARIABLE(aPeer);

    if (aAcceptInto != NULL)
    {
        *aAcceptInto = &sEndpoint;
    }

    return OT_TCP_INCOMING_CONNECTION_ACTION_ACCEPT; 
}

/**
 * @brief Confirm accept successfully
 * 
 * @param aListener 
 * @param aEndpoint 
 * @param aPeer 
 */
static void HandleTcpAcceptDone(otTcpListener *aListener, otTcpEndpoint *aEndpoint, const otSockAddr *aPeer)
{
    OT_UNUSED_VARIABLE(aListener);
    OT_UNUSED_VARIABLE(aEndpoint);

    if (aPeer != NULL)
    {
        char ipStr[OT_IP6_ADDRESS_STRING_SIZE];
        otIp6AddressToString(&aPeer->mAddress, ipStr, sizeof(ipStr));
        printf("TCP accepted connection from [%s]:%u", ipStr, aPeer->mPort);
    }

}

void tcp_led_init(otInstance *aInstance)
{
    otError err;

    memset(&sListener, 0, sizeof(sListener));
    memset(&sEndpoint, 0, sizeof(sEndpoint));


    otTcpEndpointInitializeArgs endpointInit; ///< Initialize endpoint = 1 client TCP
    memset(&endpointInit, 0, sizeof(endpointInit));


    endpointInit.mEstablishedCallback = HandleTcpEstablished; ///< bắt tay xong
    endpointInit.mSendDoneCallback = HandleTcpSendDone; ///< có data
    endpointInit.mReceiveAvailableCallback = HandleTcpReceiveAvailable; ///< send xong (free memory)
    endpointInit.mDisconnectedCallback = HandleTcpDisconnected;  ///< bị ngắt
    endpointInit.mReceiveBuffer = sReceiveBuffer;   ///< OT TCP cần vùng nhớ để chứa RX
    endpointInit.mReceiveBufferSize = sizeof(sReceiveBuffer);

    err = otTcpEndpointInitialize(aInstance, &sEndpoint, &endpointInit);
    if (err != OT_ERROR_NONE)
    {
        printf("otTcpEndpointInitialize failed: %d\n", err);
        return;
    }

    ///< Create Listener (cổng server) 
    otTcpListenerInitializeArgs listenerInit;
    memset(&listenerInit, 0, sizeof(listenerInit));
    listenerInit.mAcceptReadyCallback = HandleTcpAcceptReady; ///< có kết nối đến, bạn quyết định accept vào endpoint nào. 
    listenerInit.mAcceptDoneCallback = HandleTcpAcceptDone; ///< accept xong rồi (log) 

    err = otTcpListenerInitialize(aInstance, &sListener, &listenerInit); ///<  
    if (err != OT_ERROR_NONE)
    {
        printf("otTcpListenerInitialize failed: %d\n", err);
        return;
    }

    ///< Listen port: 3010
    otSockAddr bindAddr;
    memset(&bindAddr, 0, sizeof(bindAddr));
    bindAddr.mPort = APP_TCP_PORT; 

    err = otTcpListen(&sListener, &bindAddr);  ///< Client TCP connect vào 

    if (err != OT_ERROR_NONE)
    {
        printf("otTcpListen init failed: %d\n", err);
        return;
    }

    printf("TCP server listening on port %u\n", APP_TCP_PORT);
}
