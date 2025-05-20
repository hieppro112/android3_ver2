import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:giadienver1/database/room_services.dart';
import 'package:giadienver1/home_Screens/thuephong_Screen.dart';
import 'package:giadienver1/home_Screens/traphong_screen.dart';
import 'package:giadienver1/models/room.dart';
import 'package:giadienver1/thongbao/thong_bao_screen.dart';
import 'package:giadienver1/void/Bottom_navigation.dart';


class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
   var _roomService = RoomServices();

      var nhanphongScreen = ThuephongScreen(idphong: -1);
      var traphongScreen = TraphongScreen(idphong: -1);
      String trangthai="";

  var listRoom = <Room>[
    Room(id: 1,image: 'assets/images/room1.jpg', name: "A1.1", status: "0"),
    Room(id: 2,image: 'assets/images/room2.jpg', name: "A2.1", status: "0"),
    Room(id: 3,image: 'assets/images/room3.jpg', name: "A3.1", status: "0"),
    Room(id: 4,image: 'assets/images/room1.jpg', name: "A4.1", status: "0"),
    Room(id: 5,image: 'assets/images/room3.jpg', name: "A5.1", status: "0"),
  ];
  var valueDrop = '1';


void selcetedDropdown(String? valueNew) {
    setState(() {
      valueDrop = valueNew!;
    });
  }

  String ktra_hoatdong(String? value) {
    if(value=="0"){
      return "assets/images/ic_online.png";
    }
    return "assets/images/icon_off.png";
  }


  @override
  void initState() {
    super.initState();
    setState(() {
      insert_room();
      // read_room();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _create_header(), flex: 2),
          // Expanded(child: _create_dropDown("1"), flex: 1),
          Expanded(child: _listRoom(), flex: 8),
        ],
      ),
    );
  }

  Widget _create_header() {
    return Container(
      color: Color(0xFFFAFBF3),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         InkWell(
          onTap: () {
            print("clicked");
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Navigation(tile: "manghinh home"),
            ));
          },
          child:  Image.asset(
            'assets/images/logo.png',
            height: 150,
            fit: BoxFit.contain, 
          ),
         ),

         InkWell(
          onTap: () {
            print("clicked");
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => ManHinhThongBao(title: "manghinh thongbao"),
            ));
          },
          child:  Image.asset(
            'assets/images/chuong.png',
            height: 150,
            fit: BoxFit.contain,
          ),
         ),
        ],
      ),
    );

  }


  Future<void> read_room() async {
  var rooms = await _roomService.readRoom(); // List<Map<String, dynamic>>
  List<Room> tempList = [];

  for (var item in rooms) {
    var roomModel = Room(
      id: item['id'],
      name: item['name'],
      status: item['status'],
      image: item['image'],
    );
    tempList.add(roomModel);
  }

  setState(() {
    listRoom = tempList;
  });
}

  Future<void> insert_room() async {
  var insert = await _roomService.readRoom(); // List<Map<String, dynamic>>

  if (insert.isEmpty) {
    for (var item in listRoom) {
      await _roomService.saveRoom(item);
    }
  }
}


  Widget _listRoom() {
    return 
    GridView.builder(
      itemCount: listRoom.length,
      gridDelegate: 
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    ),
    padding: const EdgeInsets.all(10),
    itemBuilder: (context, index) {
      final room = listRoom[index];
      return main_list(room);
    },
     
    );
  }

  Widget main_list(final Room room) {
    String hd = ktra_hoatdong(room.status);
    return 
    InkWell(
      onTap: () async{
        print('id room: ${room.id}');
        if(room.status == "0"){
          trangthai = await Navigator.push(context, MaterialPageRoute(builder: (context) => ThuephongScreen(idphong: room.id )));
          setState(() {
            room.status = trangthai;
          });
        }
        else if(room.status =="1"){
          trangthai = await Navigator.push(context, MaterialPageRoute(builder: (context) => TraphongScreen(idphong: room.id,)));
          setState(() {
            room.status = trangthai;
          });
        }
      },
      child: 
      Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2
        )
      ),
      child: 
      Card(
      elevation: 4, // Độ nâng của Card (tạo bóng)
      margin: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(room.image, width: 100, height: 100, fit: BoxFit.fill),
          Text("số phòng: ${room.name}", style: TextStyle(fontSize: 20)),
          Image.asset(
            hd,
            width: 20,
            height: 20,
            fit: BoxFit.fill,
          ),
        ],
      ),
    ),
    ),
    
    );
  }

  
}
