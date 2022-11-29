Viết một chương trình sử dụng MIPS để vẽ một quả bóng di chuyển trên màn hình mô phỏng Bitmap của Mars). Nếu đối tượng đập vào cạnh của màn hình thì sẽ di chuyển theo chiều ngược lại.

Yêu cầu

-Thiết lập màn hình ở kích thước 512x512. Kích thước 1 pixel 1x1.

-Quả bóng là một đường tròn Chiều di chuyển phụthuộc vào phím người dùng bấm, gồm có (di chuyển lên (W), di chuyển xuống (S), Sang trái (A), Sang phải (D) trong bộgiảlập Keyboard and Display MMIO Simulator). Tốc độbóng di chuyển là không đổi. Vịtrí bóng ban đầu ởgiữa màn hình.

Gợi ý: Để làm một đối tượng di chuyển thì chúng ta sẽ xóa đối tượng ở vị trí cũ và vẽ đối tượng ở vị trí mới. Để xóa đối tượng chúng ta chỉ cần vẽ đối tượng đó với màu là màu nền
