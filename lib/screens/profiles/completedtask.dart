//CompletedTask object represents all info that needs to be kept/displayed regarding completed tasks
class CompletedTask {
  final String customerEmail;
  final String customerFirstName;
  final String customerLastName;
  final String customerUsername;
  final String description;
  final String location;
  final String payRate;
  final String startDate;
  final String taskCategory;
  final int taskNumber;
  const CompletedTask(
      this.customerEmail,
      this.customerFirstName,
      this.customerLastName,
      this.customerUsername,
      this.description,
      this.location,
      this.payRate,
      this.startDate,
      this.taskCategory,
      this.taskNumber);
}
