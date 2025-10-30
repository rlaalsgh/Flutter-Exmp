import 'package:fluent_ui/fluent_ui.dart';
import 'customer_model.dart';

class CustomerForm extends StatefulWidget {
  final Customer? customer; // ✅ 수정: 선택적 인자로 추가

  const CustomerForm({super.key, this.customer});

  @override
  State<CustomerForm> createState() => CustomerFormState();
}

class CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.customer?.name ?? '');
    phoneController = TextEditingController(text: widget.customer?.phone ?? '');
    emailController = TextEditingController(text: widget.customer?.email ?? '');
    addressController =
        TextEditingController(text: widget.customer?.address ?? '');
  }

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  Customer toCustomer() {
    return Customer(
      id: widget.customer?.id ?? 0,
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      address: addressController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: '거래처명',
            child: TextFormBox(
              controller: nameController,
              placeholder: '예: 홍길동상사',
              validator: (v) => v == null || v.isEmpty ? '필수 입력' : null,
            ),
          ),
          InfoLabel(
            label: '연락처',
            child: TextFormBox(
              controller: phoneController,
              placeholder: '예: 010-1234-5678',
            ),
          ),
          InfoLabel(
            label: '이메일',
            child: TextFormBox(
              controller: emailController,
              placeholder: '예: example@corp.com',
            ),
          ),
          InfoLabel(
            label: '주소',
            child: TextFormBox(
              controller: addressController,
              placeholder: '예: 서울특별시 강남구...',
            ),
          ),
        ],
      ),
    );
  }
}
