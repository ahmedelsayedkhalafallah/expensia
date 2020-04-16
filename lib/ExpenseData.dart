class ExpenseData{
  double amount;
  String description;
  String type;
  DateTime dateTime;

  ExpenseData(this.amount,this.description,this.dateTime,this.type);
  factory ExpenseData.fromJson(Map<String, dynamic> data) => new ExpenseData(data["price"],data["description"],DateTime.parse(data["date"]),data["type"]);
}