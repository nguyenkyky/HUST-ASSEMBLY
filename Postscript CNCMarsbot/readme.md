Máy gia công cơ khí chính xác CNCMarsbot được dùng để cắt tấm kim loại theo các đường nét được qui định trước.CNCMarsbot có mộtlưỡi cắt dịch chuyển trên tấm kim loại,với giả định rằng:

-Nếu lưỡi cắt dịch chuyển nhưng không cắt tấm kim loại,tức là Marsbot di chuyển nhưng không để lại vết(Track)-Nếu lưỡi cắt dịch chuyển và cắt tấm kim loại,tức là Marsbot di chuyển và có để lại vết.

Để điều khiển Marsbot cắt đúng như hình dạng mong muốn,người ta nạp vào Marsbot một mảng cấu trúc gồm 3 phầntử:

-<Góc chuyển động>, <Thời gian>, <Cắt/Khôngcắt>-

Trongđó <Gócchuyểnđộng> là góc của hàm HEADING củaMarsbot

-<Thời gian> là thời gian duy trì quá trình vận hành hiệntại

-<Cắt/Khôngcắt>thiết lập lưu vết/ không lưu vết

Thực hiện lập trình để CNC Marsbot có thể :
•	Thực hiện cắt kim loại 	
•	Nội dung postscript được lưu trữ cố định bên trong mã nguồn
•	Mã nguồn chứa 3 postscript và người dùng sử dụng 3 phím 0,4,8 trên bàn phím KeyMatrix để chọn postscript nào sẽ được gia công.
•	Một postscript chứa chữ DCE cần gia công. Hai script còn lại sinh viên tự đề xuất (tối thiểu 10 đường cắt)

