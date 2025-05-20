import 'package:flutter/foundation.dart';
import 'package:giadienver1/database/repository.dart';
import 'package:giadienver1/models/customer.dart';
import 'package:giadienver1/models/room.dart';

class RoomServices {
  final Repository _room = Repository();

  //insert
  saveRoom(Room room) async {
    return await _room.insertData('roomHotel', room.roomMap());
  }

  //read
  readRoom() async {
    return await _room.readData('roomHotel');
  }

  //insert customer
  insertCustomer(Customer customer) async {
    return await _room.isertCustomer('customertable', customer.customerToMap());
  }

  //read customer
  readCustomer() async {
    return await _room.readCustomer('customertable');
  }

  Future<List<Map<String, dynamic>>> readCustomersByRoom(int idPhong) async {
    return await _room.thongtinkhachhang(idPhong);
  }

  //xoa khach hang khi thanh toán
  Future<void> deleteCustomer(int id) async {
    await _room.xoaCustomer(id);
  }

  Future<void> updateRoomStatus(int idPhong, String status) async {
    await _room.updateCustomer(
      'roomHotel',
      {'status': status},
      'id = ?',
      [idPhong],
    );
  }
}
