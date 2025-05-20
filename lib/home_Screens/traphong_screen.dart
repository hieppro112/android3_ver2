import 'package:flutter/material.dart';
import 'package:giadienver1/database/room_services.dart';
import 'package:giadienver1/home_Screens/thanhtoan.dart';
import 'package:giadienver1/models/customer.dart';

class TraphongScreen extends StatefulWidget {
  final int idphong;
  const TraphongScreen({super.key, required this.idphong});

  @override
  State<TraphongScreen> createState() => _TraphongScreenState();
}

class _TraphongScreenState extends State<TraphongScreen> {

  final ThanhtoanScreen thanhtoanScreen = ThanhtoanScreen(title: "Thanh toán", sotien: "");
  final RoomServices _roomServices = RoomServices();
  List<Map<String, dynamic>> customers = [];
  Map<String, dynamic>? selectedCustomer;
  DateTime? checkinTime;
  DateTime? checkoutTime;
  bool free_checkout = false;

  TextEditingController nameControl = TextEditingController();
  TextEditingController cccdControl = TextEditingController();
  TextEditingController sdtControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    final data = await _roomServices.readCustomersByRoom(widget.idphong);
    setState(() {
      customers = data;
      if (data.isNotEmpty) {
        selectedCustomer = data[0];
        nameControl.text = selectedCustomer!['name'] ?? '';
        cccdControl.text = selectedCustomer!['cccd'] ?? '';
        sdtControl.text = selectedCustomer!['sdt'] ?? '';
        checkinTime =
            selectedCustomer!['ngayvao'] != null
                ? DateTime.parse(selectedCustomer!['ngayvao'])
                : null;
        checkoutTime =
            selectedCustomer!['ngayra'] != null
                ? DateTime.parse(selectedCustomer!['ngayra'])
                : null;
      }
    });
  }

  double thanhtoan(DateTime timeIn, DateTime timeOut) {
    Duration time = timeOut.difference(timeIn);
    double hour = time.inMinutes / 60;
    return 50000 * hour;
  }

  Future<void> _confirmCheckout() async {
    if (selectedCustomer == null) return;

    // Xóa khách hàng khỏi customertable
    await _roomServices.deleteCustomer(selectedCustomer!['id']);
    // Cập nhật trạng thái phòng thành "trống"
    await _roomServices.updateRoomStatus(widget.idphong, '0');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Trả phòng thành công')));

    // Tải lại danh sách khách hàng
    await _loadCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trả phòng - Phòng ${widget.idphong}'),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context, "0");
          },
        ),
      ),
      body:
          customers.isEmpty
              ? const Center(child: Text('Chưa có khách hàng nào'))
              : create_layout(),
    );
  }

  Widget create_layout() {
    return Center(
      child: Column(
        children: [
          // Dropdown để chọn khách hàng
          DropdownButton<int>(
            value: selectedCustomer?['id'],
            hint: const Text('Chọn khách hàng'),
            items:
                customers.map((customer) {
                  return DropdownMenuItem<int>(
                    value: customer['id'],
                    child: Text(customer['name'] ?? 'Không tên'),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCustomer = customers.firstWhere(
                  (c) => c['id'] == value,
                );
                nameControl.text = selectedCustomer!['name'] ?? '';
                cccdControl.text = selectedCustomer!['cccd'] ?? '';
                sdtControl.text = selectedCustomer!['sdt'] ?? '';
                checkinTime =
                    selectedCustomer!['ngayvao'] != null
                        ? DateTime.parse(selectedCustomer!['ngayvao'])
                        : null;
                checkoutTime =
                    selectedCustomer!['ngayra'] != null
                        ? DateTime.parse(selectedCustomer!['ngayra'])
                        : null;
              });
            },
          ),
          // Họ và tên
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Họ tên: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 8,
                child: TextField(
                  controller: nameControl,
                  readOnly: true, // Chỉ đọc để hiển thị
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFe7e2d3),
                    hintText: "Nhap ho va ten",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // CCCD
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "CCCD: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 8,
                child: TextField(
                  controller: cccdControl,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFe7e2d3),
                    hintText: "Nhap CCCD",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // SĐT
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "SĐT: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 8,
                child: TextField(
                  controller: sdtControl,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFe7e2d3),
                    hintText: "Nhap SĐT",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Thời gian vào
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Vào:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(flex: 8, child: time_checkin()),
            ],
          ),
          // Thời gian ra
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Ra:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(flex: 8, child: time_checkout()),
            ],
          ),
          SizedBox(height: 20),
          // Hiển thị chi phí
          if (checkinTime != null && checkoutTime != null)
            Text(
              "Thanh toán: ${thanhtoan(checkinTime!, checkoutTime!).round()} VNĐ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          SizedBox(height: 30),
          Row(
            children: [
              ElevatedButton(
                onPressed: _confirmCheckout,
                child: Text(
                  "Xác Nhận Trả Phòng",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 10,),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ThanhtoanScreen(title: "Thanh Toán", sotien: "${thanhtoan(checkinTime!, checkoutTime!).round()} VNĐ");
                  }
                  )
                  );
                },
                child: Text(
                  "Thanh Toán",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget time_checkin() {
    return Column(
      children: [
        Text(
          checkinTime != null ? "Vào: $checkinTime" : "Chưa có thời gian",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget time_checkout() {
    return Column(
      children: [
        ElevatedButton(
          onPressed:
              free_checkout
                  ? null
                  : () async {
                    int yearNow = DateTime.now().year;
                    DateTime? date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(yearNow),
                      lastDate: DateTime(yearNow + 10),
                    );

                    if (date != null) {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          checkoutTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    }
                  },
          child: Text("Cập nhật thời gian ra"),
        ),
        Text(
          checkoutTime != null ? "Ra: $checkoutTime" : "Chưa có thời gian",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
