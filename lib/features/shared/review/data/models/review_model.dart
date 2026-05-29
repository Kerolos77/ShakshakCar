import 'package:shakshak/features/shared/review/domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({
    super.statusval,
    super.msg,
    super.status,
  });

  ReviewModel.fromJson(dynamic json)
      : super(
          statusval: json['statusval'],
          msg: json['msg'],
          status: json['status'],
        );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusval'] = statusval;
    map['msg'] = msg;
    map['status'] = status;
    return map;
  }
}
