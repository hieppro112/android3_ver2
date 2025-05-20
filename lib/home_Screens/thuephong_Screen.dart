import 'package:flutter/material.dart';
import 'package:giadienver1/database/room_services.dart';
import 'package:giadienver1/models/customer.dart';

class ThuephongScreen extends StatefulWidget {
  final int idphong;
  const ThuephongScreen({super.key, required this.idphong});

  @override
  State<StatefulWidget> createState() => _ThuephongScreen();
}

class _ThuephongScreen extends State<ThuephongScreen> {
  var _customerService = RoomServices();
  Customer? customer;

  DateTime? checkinTime;
  DateTime? checkoutTime;
  bool free_checkout = false;
  var nameControl = TextEditingController();
  var cccdControl = TextEditingController();
  var sdtControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      leading: BackButton(
        onPressed: () {
          Navigator.pop(context,"0");
        },
      ),
    ), body: create_layout());
  }

  Widget create_layout() {
    return Center(
      child: Column(
        children: [
          //ho va ten
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
          //cccd
          SizedBox(height: 20),
          //CCCD
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
                  keyboardType: TextInputType.numberWithOptions(),
                  controller: cccdControl,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFe7e2d3),
                    hintText: "Nhap CCCD:",
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
          //sdt
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
                  keyboardType: TextInputType.numberWithOptions(),
                  controller: sdtControl,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFe7e2d3),
                    hintText: "Nhap SĐT:",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),

          //Thoi gian vao
          SizedBox(height: 20),
          //thoi gian vao
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

          //thoi gian ra
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
          Row(
            children: [
              Checkbox(
                value: free_checkout,
                onChanged: (value) {
                  setState(() {
                    free_checkout = value!;
                  });
                  if(free_checkout==true){
                    checkoutTime=DateTime.now();
                  }
                },
              ),
              Text(
                "Chưa xác định thời gian trả phòng",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),

          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              var name = nameControl.text;
              var cccd = cccdControl.text;
              var sdt = sdtControl.text;
              var ngayvao = checkinTime;
              var ngayra = checkoutTime;
              var idphong = widget.idphong;

              if (name.isEmpty ||
                  cccd.isEmpty ||
                  sdt.isEmpty ||
                  ngayvao == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng điền đầy đủ thông tin'),
                  ),
                );
                return;
              }

              customer = Customer(
                name: name,
                sdt: sdt,
                cccd: cccd,
                ngayvao: ngayvao,
                ngayra: ngayra,
                idphong: idphong,
              );

              var result = await _customerService.insertCustomer(customer!);
              Navigator.pop(context, "1");
              print("cliked");
            },
            child: Text(
              "Xác Nhận",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  //thiet lap gio vao
  Widget time_checkin() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            int yaerNow = DateTime.now().year;
            DateTime? date = await showDatePicker(
              context: context,
              firstDate: DateTime(yaerNow),
              lastDate: DateTime(yaerNow + 10),
            ); // thiet lap thoi gian cho dong lich chon

            if (date != null) {
              TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              //thiet lap gio phut
              if (time != null) {
                setState(() {
                  checkinTime = DateTime(
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
          child: Text("Chọn thời gian vào"),
        ),
        Text(
          checkinTime != null ? "Vào: $checkinTime" : "chua chọn thời gian",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  //thiet lap gio ra
  Widget time_checkout() {
    return Column(
      children: [
        ElevatedButton(
          onPressed:
              free_checkout
                  ? null
                  : () async {
                    int yaerNow = DateTime.now().year;
                    DateTime? date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(yaerNow),
                      lastDate: DateTime(yaerNow + 10),
                    ); // thiet lap thoi gian cho dong lich chon

                    if (date != null) {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      //thiet lap gio phut
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
          child: Text("Chọn thời gian ra"),
        ),
        Text(
          (checkoutTime != null && free_checkout == false)
              ? "Ra: $checkoutTime"
              : "chua chọn thời gian",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
