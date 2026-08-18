// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressAdapter extends TypeAdapter<Address> {
  @override
  final int typeId = 1;

  @override
  Address read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Address(
      id: fields[0] as String?,
      customer: fields[1] as String?,
      firstName: fields[2] as String?,
      lastName: fields[3] as String?,
      email: fields[4] as String?,
      phone: fields[5] as String?,
      houseNo: fields[6] as int?,
      address: fields[7] as String?,
      street: fields[8] as String?,
      zipCode: fields[9] as String?,
      city: fields[10] as String?,
      state: fields[11] as String?,
      country: fields[12] as String?,
      latitude: fields[13] as String?,
      longitude: fields[14] as String?,
      type: fields[15] as String?,
      isDefault: fields[16] as bool?,
      createdAt: fields[17] as DateTime?,
      updatedAt: fields[18] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Address obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customer)
      ..writeByte(2)
      ..write(obj.firstName)
      ..writeByte(3)
      ..write(obj.lastName)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.phone)
      ..writeByte(6)
      ..write(obj.houseNo)
      ..writeByte(7)
      ..write(obj.address)
      ..writeByte(8)
      ..write(obj.street)
      ..writeByte(9)
      ..write(obj.zipCode)
      ..writeByte(10)
      ..write(obj.city)
      ..writeByte(11)
      ..write(obj.state)
      ..writeByte(12)
      ..write(obj.country)
      ..writeByte(13)
      ..write(obj.latitude)
      ..writeByte(14)
      ..write(obj.longitude)
      ..writeByte(15)
      ..write(obj.type)
      ..writeByte(16)
      ..write(obj.isDefault)
      ..writeByte(17)
      ..write(obj.createdAt)
      ..writeByte(18)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
