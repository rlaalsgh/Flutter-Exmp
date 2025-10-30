import 'package:fluent_ui/fluent_ui.dart';
import 'customer_model.dart';

class CustomerForm extends StatefulWidget {
  const CustomerForm({super.key});

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(label: '거래처명', child: TextBox(controller: nameController, placeholder: '예: 홍길동상사')),
          const SizedBox(height: 10),
          InfoLabel(label: '연락처', child: TextBox(controller: phoneController, placeholder: '예: 010-1234-5678')),
          const SizedBox(height: 10),
          InfoLabel(label: '이메일', child: TextBox(controller: emailController, placeholder: '예: example@corp.com')),
          const SizedBox(height: 10),
          InfoLabel(label: '주소', child: TextBox(controller: addressController, placeholder: '예: 서울특별시 강남구...')),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Button(child: const Text('취소'), onPressed: () => Navigator.pop(context)),
                const SizedBox(width: 10),
                FilledButton(
                  child: const Text('등록'),
                  onPressed: () {
                    final newCustomer = Customer(
                      id: DateTime.now().millisecondsSinceEpoch,
                      name: nameController.text,
                      phone: phoneController.text,
                      email: emailController.text,
                      address: addressController.text,
                    );
                    Navigator.pop(context, newCustomer);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
