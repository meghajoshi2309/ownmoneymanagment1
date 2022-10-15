class TransactionModel {
  String? uid;
  String? tid;
  num? amount;
  String? date;
  String? category;
  String? paymentmode;
  String? transactiontype;

  TransactionModel(
      {this.uid,
      this.tid,
      this.amount,
      this.date,
      this.category,
      this.paymentmode,
      this.transactiontype});

  //Taking data from server using map
  factory TransactionModel.fromMap(map) {
    return TransactionModel(
        uid: map['uid'],
        tid: map['tid'],
        amount: map['amount'],
        date: map['date'],
        category: map['category'],
        paymentmode: map['paymentmode'],
        transactiontype: map['transactiontype']);
  }

  //sending data to server using map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'tid': tid,
      'amount': amount,
      'date': date,
      'category': category,
      'paymentmode': paymentmode,
      'transactiontype': transactiontype,
    };
  }
}
