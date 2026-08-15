# Silicon Labs IoT Development Guide for Google Antigravity 2.0

Tài liệu hướng dẫn toàn diện dành cho **Kỹ sư Phần mềm Nhúng & Đội ngũ Phát triển Dịch vụ IoT** sử dụng nền tảng AI **Antigravity 2.0** với vi điều khiển Silicon Labs (EFR32MG24 / Simplicity SDK / Gecko SDK).

---

## 1. Tổng quan Hệ thống Customization

Toàn bộ hệ thống được xây dựng và ánh xạ chính xác theo quy trình 6 giai đoạn trong sơ đồ [AI_Coding.mmd](file:///e:/CODE/Silicon_Labs/Simplicity6/empty/AI_Coding.mmd):

```
┌─────────────────────────────────────────────────────────────────────────────┐
│ 1. INITIALIZATION & GUARDRAILS                                              │
│    - .agents/rules/ (Quy chuẩn EFR32, Simplicity SDK, Deep Module, Quality) │
│    - .agents/hooks.json (Chặn sửa autogen/, auto build check)               │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ 2. REQUIREMENT ALIGNMENT                                                    │
│    - /grill-me (Phỏng vấn đệ quy 5 tầng: HW, Protocol, Concurrency, API)   │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ 3. DECOMPOSITION                                                            │
│    - /write-a-prd (Sinh PRD-<feature>.md chuẩn nhúng)                       │
│    - /prd-to-issues (Bóc tách Vertical Tracer Bullets & Vẽ đồ thị DAG)       │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ 4. ISOLATED AFK EXECUTION & TDD                                             │
│    - /embedded-tdd (Vòng lặp Red-Green-Refactor, Host Pytest)               │
│    - /silabs-build-verify (CMake Presets + ARM GCC + Cppcheck)              │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ 5. ARCHITECTURE REFACTORING                                                 │
│    - /improve-codebase-architecture (Loại bỏ Shallow Modules, chuẩn hóa .h) │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ 6. VERIFICATION & DELIVERY                                                  │
│    - /audit-reviewer (Clean-Context Reviewer Gate, Commander Flash)         │
│    - walkthrough.md (Báo cáo bằng chứng hoàn thành)                         │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Cấu trúc Thư mục `.agents/`

```
.agents/
├── rules/                                   # Quy chuẩn & Ràng buộc tự động nạp
│   ├── 01-workflow-guardrails.md            # Quy trình 6 Phase & Guardrails
│   ├── 02-silabs-embedded-standards.md      # EFR32, BLE, RTOS, Power, Memory
│   ├── 03-deep-module-architecture.md       # Chuẩn Deep Module C & Python
│   └── 04-testing-quality-gates.md          # Tiêu chí nghiệm thu & Commands
├── skills/                                  # Các kỹ năng chuyên biệt (Runbooks)
│   ├── grill-me/SKILL.md                    # Phỏng vấn làm rõ yêu cầu
│   ├── write-a-prd/SKILL.md                 # Tạo PRD kỹ thuật nhúng
│   ├── prd-to-issues/SKILL.md               # Bóc tách Task DAG
│   ├── embedded-tdd/SKILL.md                # Quy trình TDD nhúng & Host
│   ├── silabs-build-verify/SKILL.md         # CMake + GCC + Commander
│   ├── improve-codebase-architecture/SKILL.md # Refactor Deep Modules
│   └── audit-reviewer/SKILL.md              # Reviewer độc lập
├── scripts/                                 # Scripts tự động hóa
│   ├── guard_autogen.py                     # Hook chặn sửa file autogen/
│   └── build_check.ps1                      # Script build nhanh CMake/Ninja
├── plugins/
│   └── silabs-iot-services/                 # Plugin đóng gói độc lập để tái sử dụng
│       ├── plugin.json
│       ├── rules/
│       ├── skills/
│       └── hooks.json
└── hooks.json                               # Cấu hình Lifecycle Hooks
```

---

## 3. Hướng dẫn sử dụng các Slash Commands

Trong lúc tương tác với Antigravity trong cửa sổ Chat, bạn có thể gõ hoặc đề xuất các lệnh sau:

| Slash Command | Giai đoạn | Mô tả & Khi nào sử dụng |
| :--- | :--- | :--- |
| `/grill-me` | **Phase 2** | Khi bạn có một ý tưởng / tính năng IoT mới. AI sẽ phỏng vấn từng câu hỏi về phần cứng, BLE GATT, RTOS, và công suất để thống nhất yêu cầu trước khi code. |
| `/write-a-prd` | **Phase 3** | Sau khi phỏng vấn xong, kích hoạt lệnh này để AI sinh tài liệu đặc tả kỹ thuật `PRD-<feature>.md`. |
| `/prd-to-issues` | **Phase 3** | Bóc tách PRD thành các nhiệm vụ dạng Vertical Tracer Bullet và vẽ đồ thị phụ thuộc (DAG). |
| `/embedded-tdd` | **Phase 4** | Hướng dẫn AI viết test trước (Pytest cho Host hoặc Mock/Buffer tests cho C), sau đó mới viết logic xử lý. |
| `/silabs-build-verify` | **Phase 4 & 6** | Thực hiện build kiểm tra qua CMake/Ninja và chạy static analysis `cppcheck`. |
| `/improve-codebase-architecture` | **Phase 5** | Quét mã nguồn để phát hiện "Shallow Modules", thu gọn file header `.h` (tối đa 3-7 hàm public), chuyển các hàm phụ trợ thành `static` trong file `.c`. |
| `/audit-reviewer` | **Phase 6** | Đóng vai reviewer độc lập với ngữ cảnh sạch để kiểm tra rò rỉ bộ nhớ, race condition, và tạo `walkthrough.md`. |

---

## 4. Các Quy chuẩn Bắt buộc (Rules & Guardrails)

### A. Bảo vệ mã nguồn tự sinh (`autogen/`)
- Mọi file trong `autogen/`, `simplicity_sdk_*/`, `.slps` đều được bảo vệ bởi hook `guard_autogen.py`. AI sẽ tự động bị từ chối nếu cố tình chỉnh sửa các file này.
- **Cách làm đúng:** Cấu hình components trong file `.slcp` hoặc viết code ứng dụng trong thư mục `src/module/`.

### B. Kiến trúc Deep Module cho C
- **Public Header (`src/module/<name>/include/<name>.h`):** Chỉ chứa tối đa 3-7 hàm public (`_init`, `_process`, `_deinit`, getters/setters). Tuyệt đối không để lộ biến global, struct nội bộ hay thanh ghi phần cứng.
- **Source (`src/module/<name>/source/<name>.c`):** Tất cả hàm helper phải có từ khóa `static`. Trạng thái module lưu trong `static struct s_ctx`.

### C. Quản lý Bộ nhớ & Năng lượng
- Tuyệt đối **KHÔNG DÙNG DYNAMIC ALLOCATION** (`malloc`, `free`). 100% sử dụng static allocation với kích thước xác định tại thời điểm biên dịch.
- Trả về và kiểm tra mã lỗi `sl_status_t` ở tất cả các hàm.
- Không dùng hàm delay chặn (`while(1)`, `sl_udelay_wait`) trong `app_process_action()`.

---

## 5. Hướng dẫn Tái sử dụng Plugin cho các Dự án Silicon Labs khác

Bạn có thể chia sẻ và tái sử dụng bộ cấu hình này cho bất kỳ dự án Simplicity Studio nào trong team theo 3 cách:

### Cách 1: Copy thư mục `.agents/` vào Repo dự án mới (Khuyên dùng cho Team Git)
1. Copy nguyên thư mục `.agents/` từ dự án hiện tại vào thư mục gốc của repo dự án Silicon Labs mới.
2. Commit `.agents/` lên Git repository của dự án.
3. Khi bất kỳ thành viên nào trong team mở dự án bằng Antigravity IDE, toàn bộ Rules, Skills và Hooks sẽ tự động được nhận diện mà không cần cài đặt thêm.

### Cách 2: Cài đặt Plugin toàn cục trên máy cá nhân (Global Plugin)
Nếu bạn muốn bộ kỹ năng này tự động áp dụng cho tất cả các dự án trên máy tính cá nhân:
1. Mở thư mục cấu hình toàn cục:
   `C:\Users\<Tên_User>\.gemini\config\plugins\`
2. Copy thư mục `.agents/plugins/silabs-iot-services/` vào đường dẫn trên.
3. Antigravity sẽ tự động kích hoạt bộ kỹ năng SiLabs IoT Services cho mọi workspace bạn mở.

### Cách 3: Sử dụng `plugins.json` để chia sẻ qua đường dẫn mạng nội bộ
Trong thư mục dự án mới, tạo file `.agents/plugins.json` và trỏ đường dẫn tới thư mục plugin dùng chung:
```json
{
  "plugins": [
    {
      "path": "E:/CODE/Silicon_Labs/Common/plugins/silabs-iot-services"
    }
  ]
}
```

---

## 6. Lệnh Dòng Lệnh Nhanh Cho Kỹ Sư (Cheat Sheet)

```powershell
# 1. Build Firmware (CMake + Ninja Multi-Config)
cmake --build cmake_gcc/build --config base

# 2. Chạy Static Analysis (Cppcheck)
cppcheck --enable=warning,style,performance,portability src/

# 3. Flash Firmware xuống mạch EFR32MG24 (BRD4187C)
commander flash cmake_gcc/build/empty.hex --device EFR32MG24

# 4. Kiểm tra Device Info & Reset MCU
commander device info
commander device reset

# 5. Chạy Test Suite cho Python BLE Host App
pytest tools/ble_host/tests/ -v
```
