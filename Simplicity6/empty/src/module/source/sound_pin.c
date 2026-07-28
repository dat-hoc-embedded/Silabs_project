#include "sound_pin.h"
#include "app_log.h"
#include "sl_status.h"
#include "sl_gpio.h"
#include "sl_led.h"
#include "sl_simple_led_instances.h"
#include "sl_sleeptimer.h"
#include "sl_udelay.h"

#define SOUND_PIN  5
#define SOUND_PORT SL_GPIO_PORT_A

static sl_gpio_t pin_sound = { 
    .port = SOUND_PORT, 
    .pin = SOUND_PIN 
};

// =============================================================================
// Định nghĩa tần số nốt nhạc (Hz)
// Sheet nhạc: Khóa Sol, 1 bémol (Bb) → Tone Dm (Rê thứ)
// Thang âm Dm tự nhiên: D  E  F  G  A  Bb  C  D
// =============================================================================
#define NOTE_REST 0
#define NOTE_C4   262
#define NOTE_D4   294
#define NOTE_E4   330
#define NOTE_F4   349
#define NOTE_G4   392
#define NOTE_A4   440
#define NOTE_Bb4  466   // Si giáng (trong key signature)
#define NOTE_C5   523
#define NOTE_D5   587
#define NOTE_E5   659
#define NOTE_F5   698

typedef struct {
    uint16_t frequency; // Tần số nốt nhạc (Hz)
    uint16_t duration;  // Thời lượng phát (ms)
} note_t;

// =============================================================================
// "Sóng Gió" - Jack & K-ICM
// Chuyển soạn từ sheet nhạc (Tone Dm, nhịp 4/4, tempo ~120 BPM)
//
// Quy ước thời lượng (ms):
//   Nốt móc đơn (♪ eighth)  = 250
//   Nốt đen (♩ quarter)     = 500
//   Nốt đen chấm (♩.)      = 750
//   Nốt trắng (𝅗𝅥 half)     = 1000
//   Nốt trắng chấm (𝅗𝅥.)   = 1500
// =============================================================================
static const note_t melody[] = {

    // ── INTRO (dòng 1 sheet: đàn dạo) ──────────────────────────
    { NOTE_REST, 500 },
    { NOTE_A4,  250 }, { NOTE_REST, 250 },
    { NOTE_D4,  250 }, { NOTE_A4,  250 }, { NOTE_C5,  250 }, { NOTE_Bb4, 500 },
    { NOTE_REST, 250 },
    { NOTE_A4,  250 }, { NOTE_G4,  250 }, { NOTE_REST, 250 },
    { NOTE_F4,  250 }, { NOTE_G4,  250 }, { NOTE_A4,  500 },
    { NOTE_REST, 500 },

    // ── VERSE 1 ─────────────────────────────────────────────────
    // "Hồng" (nốt lấy đà - pickup)
    { NOTE_D4,  250 },

    // "trần trên đôi cánh tay" [Am → Dm]
    //  F4(♩)  F4(♩)  A4(♩)  A4(♩.)  G4(♪) | A4(𝅗𝅥)
    { NOTE_F4,  500 }, { NOTE_F4,  500 }, { NOTE_A4,  500 },
    { NOTE_A4,  750 }, { NOTE_G4,  250 }, { NOTE_A4,  1000 },
    { NOTE_REST, 250 },

    // "Họa đời em trong phút giây" [Em7 → Am7]
    //  A4(♩)  A4(♩)  G4(♪)  F4(♪) | G4(♩.)  A4(𝅗𝅥)
    { NOTE_A4,  500 }, { NOTE_A4,  500 }, { NOTE_G4,  250 },
    { NOTE_F4,  250 }, { NOTE_G4,  750 }, { NOTE_A4,  1000 },
    { NOTE_REST, 250 },

    // "Từ ngày thơ ấy còn ngủ mơ" [G → C]
    //  Bb4(♩.)  A4(♪) G4(♪) A4(♪) G4(♪) F4(♪) | G4(♩)
    { NOTE_Bb4, 750 }, { NOTE_A4,  250 }, { NOTE_G4,  250 },
    { NOTE_A4,  250 }, { NOTE_G4,  250 }, { NOTE_F4,  250 }, { NOTE_G4,  500 },
    { NOTE_REST, 250 },

    // "đến khi em thờ ơ ờ" [C → F]
    //  F4(♪) E4(♪) D4(♪) | F4(♩.)  D4(𝅗𝅥.)
    { NOTE_F4,  250 }, { NOTE_E4,  250 }, { NOTE_D4,  250 },
    { NOTE_F4,  750 }, { NOTE_D4,  1500 },
    { NOTE_REST, 500 },

    // ── VERSE 2 ─────────────────────────────────────────────────
    // "Lòng" (pickup)
    { NOTE_D4,  250 },

    // "người anh đâu có hay" [Am → Dm]
    { NOTE_F4,  500 }, { NOTE_F4,  500 }, { NOTE_A4,  500 },
    { NOTE_A4,  750 }, { NOTE_G4,  250 }, { NOTE_A4,  1000 },
    { NOTE_REST, 250 },

    // "Một ngày khi vỗ cánh bay" [Em7 → Am7]
    { NOTE_A4,  500 }, { NOTE_A4,  250 }, { NOTE_G4,  250 },
    { NOTE_F4,  250 }, { NOTE_G4,  750 }, { NOTE_A4,  1000 },
    { NOTE_REST, 250 },

    // "từ người yêu hóa thành người dưng" [G → C]
    { NOTE_Bb4, 750 }, { NOTE_A4,  250 }, { NOTE_G4,  250 },
    { NOTE_A4,  250 }, { NOTE_G4,  250 }, { NOTE_F4,  250 },
    { NOTE_G4,  250 }, { NOTE_A4,  500 },
    { NOTE_REST, 250 },

    // "đến khi ta tự xưng à" [Am → Dm]
    { NOTE_A4,  250 }, { NOTE_G4,  250 }, { NOTE_F4,  250 },
    { NOTE_REST, 250 }, { NOTE_D4,  250 }, { NOTE_A4,  1500 },
    { NOTE_REST, 500 },

    // ── PRE-CHORUS ──────────────────────────────────────────────
    // "Thương em bờ vai nhỏ nhoi" [Fmaj7 → Bbmaj7]
    //  C5(♪) C5(♪) A4(♩) | A4(♩) Bb4(♪) A4(♩.)
    { NOTE_C5,  250 }, { NOTE_C5,  250 }, { NOTE_A4,  500 },
    { NOTE_A4,  500 }, { NOTE_Bb4, 250 }, { NOTE_A4,  750 },
    { NOTE_REST, 250 },

    // "đôi mắt hóa mây đêm" [G → C]
    //  C5(♩) C5(♪) Bb4(♪) | A4(♩) G4(♩.)
    { NOTE_C5,  500 }, { NOTE_C5,  250 }, { NOTE_Bb4, 250 },
    { NOTE_A4,  500 }, { NOTE_G4,  750 },
    { NOTE_REST, 250 },

    // "Thương sao mùi dạ lý hương" [Em → Am]
    //  Bb4(♪) Bb4(♪) A4(♩) | G4(♩) E4(♪) D4(♩.)
    { NOTE_Bb4, 250 }, { NOTE_Bb4, 250 }, { NOTE_A4,  500 },
    { NOTE_G4,  500 }, { NOTE_E4,  250 }, { NOTE_D4,  750 },
    { NOTE_REST, 250 },

    // "vương vấn mãi bên thềm" [Am → Dm]
    //  G4(♩) A4(♩) Bb4(♪) | A4(♩) G4(𝅗𝅥)
    { NOTE_G4,  500 }, { NOTE_A4,  500 }, { NOTE_Bb4, 250 },
    { NOTE_A4,  500 }, { NOTE_G4,  1000 },
    { NOTE_REST, 500 },

    // "Đời phiêu du cố tìm một người thật lòng" [F → Bb]
    //  D5(♩) D5(♪) C5(♪) | Bb4(♩) Bb4(♪) A4(♪) | Bb4(♪) C5(♪) D5(♩.)
    { NOTE_D5,  500 }, { NOTE_D5,  250 }, { NOTE_C5,  250 },
    { NOTE_Bb4, 500 }, { NOTE_Bb4, 250 }, { NOTE_A4,  250 },
    { NOTE_Bb4, 250 }, { NOTE_C5,  250 }, { NOTE_D5,  750 },
    { NOTE_REST, 250 },

    // "Dẫu trời mênh mông anh nhớ em" [G → C]  [C → F]  [E → A]
    //  C5(♩) C5(♪) Bb4(♪) | A4(♩) G4(♪) A4(♩.) | F4(𝅗𝅥)
    { NOTE_C5,  500 }, { NOTE_C5,  250 }, { NOTE_Bb4, 250 },
    { NOTE_A4,  500 }, { NOTE_G4,  250 }, { NOTE_A4,  750 },
    { NOTE_F4,  1000 },
    { NOTE_REST, 250 },

    // "Chim kia về vẫn có đôi" [Fmaj7 → Bbmaj7]
    //  C5(♪) C5(♪) A4(♩) | A4(♩) Bb4(♪) A4(♩.)
    { NOTE_C5,  250 }, { NOTE_C5,  250 }, { NOTE_A4,  500 },
    { NOTE_A4,  500 }, { NOTE_Bb4, 250 }, { NOTE_A4,  750 },
    { NOTE_REST, 250 },

    // "Sao chẳng số phu thê" [G → C]
    //  C5(♩) C5(♪) Bb4(♪) | A4(♩) G4(♩.)
    { NOTE_C5,  500 }, { NOTE_C5,  250 }, { NOTE_Bb4, 250 },
    { NOTE_A4,  500 }, { NOTE_G4,  750 },
    { NOTE_REST, 250 },

    // "Em ơi đừng xa cách tôi" [Em → Am]
    //  Bb4(♪) Bb4(♪) A4(♩) | G4(♩) A4(♩) G4(𝅗𝅥.)
    { NOTE_Bb4, 250 }, { NOTE_Bb4, 250 }, { NOTE_A4,  500 },
    { NOTE_G4,  500 }, { NOTE_A4,  500 }, { NOTE_G4,  1500 }
};

#define MELODY_LENGTH (sizeof(melody) / sizeof(melody[0]))

// Trạng thái xử lý
typedef enum {
    SOUND_STATE_IDLE,
    SOUND_STATE_PLAYING,
    SOUND_STATE_WAIT_RELEASE
} sound_state_t;

static sound_state_t current_state = SOUND_STATE_IDLE;

// Hàm phát 1 nốt nhạc bằng sóng vuông tần số tương ứng trên chân GPIO
static void play_tone(uint16_t freq, uint16_t duration_ms) {
    if (freq == 0) {
        sl_led_turn_off(&sl_led_led0);
        sl_sleeptimer_delay_millisecond(duration_ms);
        return;
    }

    uint32_t half_period_us = 1000000 / (2 * freq);
    uint32_t elapsed_us = 0;
    uint32_t target_us = (uint32_t)duration_ms * 1000;

    while (elapsed_us < target_us) {
        sl_led_toggle(&sl_led_led0);
        sl_udelay_wait(half_period_us);
        elapsed_us += half_period_us;
    }
    sl_led_turn_off(&sl_led_led0);
}

// Hàm phát toàn bộ bản nhạc
static void play_melody(void) {
    for (size_t i = 0; i < MELODY_LENGTH; i++) {
        play_tone(melody[i].frequency, melody[i].duration);
        sl_udelay_wait(25000); // Khoảng nghỉ 25ms giữa các nốt
    }
    sl_led_turn_off(&sl_led_led0);
}

void init_pin_sound(void) {
    sl_gpio_set_pin_mode(&pin_sound, SL_GPIO_MODE_INPUT_PULL, 1);
    sl_led_turn_off(&sl_led_led0);
}

void sound_pin_process(void) {
    bool pin_val = true;
    sl_gpio_get_pin_input(&pin_sound, &pin_val);

    switch (current_state) {
        case SOUND_STATE_IDLE:
            if (pin_val == false) {
                app_log_info("Phat hien am thanh! Phat nhac Song Gio...\n");
                current_state = SOUND_STATE_PLAYING;
                play_melody();
                app_log_info("Phat nhac xong.\n");
                current_state = SOUND_STATE_WAIT_RELEASE;
            }
            break;

        case SOUND_STATE_PLAYING:
            break;

        case SOUND_STATE_WAIT_RELEASE:
            if (pin_val == true) {
                current_state = SOUND_STATE_IDLE;
            }
            break;
    }
}





