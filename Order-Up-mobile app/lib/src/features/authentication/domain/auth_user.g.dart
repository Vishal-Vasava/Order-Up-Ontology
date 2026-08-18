// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthUserAdapter extends TypeAdapter<AuthUser> {
  @override
  final int typeId = 0;

  @override
  AuthUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthUser(
      id: fields[0] as String?,
      fbId: fields[1] as String?,
      email: fields[2] as String?,
      phone: fields[3] as String?,
      firstName: fields[4] as String?,
      lastName: fields[5] as String?,
      gender: fields[6] as String?,
      version: fields[7] as String?,
      signupType: fields[8] as String?,
      deviceId: fields[9] as String?,
      fcmId: fields[10] as String?,
      device: fields[11] as String?,
      latitude: fields[12] as String?,
      longitude: fields[13] as String?,
      userType: fields[14] as String?,
      status: fields[15] as bool?,
      addressLine: fields[16] as String?,
      zipCode: fields[17] as String?,
      cart: (fields[18] as List?)?.cast<dynamic>(),
      createdAt: fields[19] as DateTime?,
      updatedAt: fields[20] as DateTime?,
      address: (fields[21] as List?)?.cast<Address>(),
      imageUrl: fields[22] as String?,
      authUserId: fields[23] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AuthUser obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fbId)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.firstName)
      ..writeByte(5)
      ..write(obj.lastName)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.version)
      ..writeByte(8)
      ..write(obj.signupType)
      ..writeByte(9)
      ..write(obj.deviceId)
      ..writeByte(10)
      ..write(obj.fcmId)
      ..writeByte(11)
      ..write(obj.device)
      ..writeByte(12)
      ..write(obj.latitude)
      ..writeByte(13)
      ..write(obj.longitude)
      ..writeByte(14)
      ..write(obj.userType)
      ..writeByte(15)
      ..write(obj.status)
      ..writeByte(16)
      ..write(obj.addressLine)
      ..writeByte(17)
      ..write(obj.zipCode)
      ..writeByte(18)
      ..write(obj.cart)
      ..writeByte(19)
      ..write(obj.createdAt)
      ..writeByte(20)
      ..write(obj.updatedAt)
      ..writeByte(21)
      ..write(obj.address)
      ..writeByte(22)
      ..write(obj.imageUrl)
      ..writeByte(23)
      ..write(obj.authUserId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
