class Faq {
  Faq.fromJson(Map<String, dynamic> json) {
    faqId = json['faq_id'];
    question = json['question'];
    answer = json['answer'];
  }

  Faq({this.faqId, this.question, this.answer});
  int? faqId;
  String? question;
  String? answer;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['faq_id'] = faqId;
    data['question'] = question;
    data['answer'] = answer;
    return data;
  }
}
