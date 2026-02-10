#include "app_udp_led.h"


#define APP_UDP_PORT 3010
#define MAX_RX 128

// static otInstance *sInstance      = NULL;

static otUdpSocket sUdpSocket;

static void SendUdpEcho(otInstance                 *aInstance,
                        const otMessageInfo        *aMessageInfo,
                        const uint8_t              *aPayload,
                        uint16_t                    aLength)
{
    otError    error;
    otMessage *response;
    otMessageInfo replyInfo;

    if (aLength == 0)
    {
        return;
    }

    memset(&replyInfo, 0, sizeof(replyInfo));
    replyInfo.mPeerAddr = aMessageInfo->mPeerAddr;   
    replyInfo.mPeerPort = aMessageInfo->mPeerPort;
    replyInfo.mSockAddr = aMessageInfo->mSockAddr;
    replyInfo.mSockPort = aMessageInfo->mSockPort;

    response = otUdpNewMessage(aInstance, NULL); // tạo message trả lời
    if (response == NULL)
    {
        return;
    }

    char* echoPayload = strcat(aPayload, " echo");
    error = otMessageAppend(response, echoPayload, aLength + 5);   // copy đúng bytes vừa nhận vào message đó. 
    if (error != OT_ERROR_NONE)
    {
        otMessageFree(response);
        return;
    }

    error = otUdpSend(aInstance, &sUdpSocket, response, &replyInfo);    
    if (error != OT_ERROR_NONE)
    {
        otMessageFree(response);    
    }
}

void HandleUdpReceive(void *aContext, otMessage *aMessage, const otMessageInfo *aMessageInfo)
{
    uint16_t length;
    otInstance *instance = (otInstance *)aContext;

    OT_UNUSED_VARIABLE(aContext);
    OT_UNUSED_VARIABLE(aMessageInfo);

    uint8_t echoBuf[MAX_RX];
    char buf[MAX_RX];
    int len = (int)otMessageGetLength(aMessage) - (int)otMessageGetOffset(aMessage);
    

    if (len <= 0 )
    {
        return;
    }
    if (len >= MAX_RX)
    {
        len = MAX_RX - 1;
    }
    
    length = otMessageRead(aMessage, otMessageGetOffset(aMessage), echoBuf, (uint16_t)len);

    memcpy(buf, echoBuf, length);
    buf[length] = '\0'; // Null-terminate the string

    while (len >0 && (buf[len -1] == '\n' || buf[len -1] == '\r' || buf[len -1] == ' ' || buf[len -1] == '\t'))
    {
        buf[--len] = '\0';
    }

    if (instance != NULL)
    {
        SendUdpEcho(instance, aMessageInfo, echoBuf, length);
    }

    if (strcmp(buf, "led on") == 0)
    {
        sl_led_turn_on(&sl_led_led0);
        printf("Received UDP message: %s - LED turned ON\n", buf);
    }
    else if (strcmp(buf, "led off") == 0)
    {
        sl_led_turn_off(&sl_led_led0);
        printf("Received UDP message: %s - LED turned OFF\n", buf);
    }
    else if (strcmp(buf, "led toggle") == 0)
    {
        sl_led_toggle(&sl_led_led0);
        printf("Received UDP message: %s - LED toggled\n", buf);
    }
    else
    {
        printf("Received UDP message: %s - Unknown command\n", buf);
    }

    // send ACK 
    // const char msg[] = "Action Completed";
    // const size_t msgLen = strlen(msg);
    // otIp6Address destAddr;
    // // Replace with actual OTBR mesh-local/global address (must match dataset prefix).
    // otIp6AddressFromString("fd3a:b82a:8255:c2db:d328:43a8:b6d4:b780", &destAddr);
    // udp_send_message(sInstance, &destAddr, 3011, (const uint8_t *)msg, (uint16_t)msgLen);

}

/**
 * @brief 
 * 
 * @param aInstance 
 * @param localport 
 */
void Udp_led_init(otInstance *aInstance, uint16_t localport)
{
    otError error;
    otSockAddr  ot_SockAddr;

    memset(&sUdpSocket, 0, sizeof(sUdpSocket));     

    error = otUdpOpen(aInstance, &sUdpSocket, HandleUdpReceive, aInstance);
    assert(error == OT_ERROR_NONE);

    memset(&ot_SockAddr, 0, sizeof(ot_SockAddr));
    ot_SockAddr.mPort = localport;

    error = otUdpBind(aInstance, &sUdpSocket, &ot_SockAddr, OT_NETIF_THREAD_HOST);
    assert(error == OT_ERROR_NONE);
}

