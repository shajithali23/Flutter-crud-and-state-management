import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/login_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();
  String name = "Name";
  TextInputType textInputType = TextInputType.phone;
  var unique_id;
  final databaseRef = FirebaseFirestore.instance;
  late CollectionReference _pro;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    unique_id = _firebaseAuth.currentUser!.uid.toString();
    // ignore: unnecessary_cast
    _pro = FirebaseFirestore.instance
        .collection("users")
        .doc(unique_id)
        .collection("products") as CollectionReference<Object?>;
  }

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String method = "create";
    if (documentSnapshot != null) {
      method = "update";
      debugPrint("UPDATE");
      _nameController.text = documentSnapshot['product_name'];
      _valueController.text = documentSnapshot['price'].toString();
      // debugPrint(documentSnapshot['name']);
      // debugPrint(documentSnapshot['price'].toString());
    } else {
      debugPrint("CREATE");
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldWidget(
                    name: "Name",
                    nameController: _nameController,
                    textInputType: TextInputType.name),
                const SizedBox(
                  height: 16,
                ),
                TextFieldWidget(
                    name: "Price",
                    nameController: _valueController,
                    textInputType: TextInputType.number),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final String? name = _nameController.text;
                    final double? price =
                        double.tryParse(_valueController.text);
                    if (name != null && price != null) {
                      if (method == "create") {
                        // await _products.add({"name": name, "price": price});
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(_firebaseAuth.currentUser!.uid.toString())
                            .collection("products")
                            .doc()
                            .set({'product_name': name, 'price': price});
                        // await pro
                      } else {
                        // debugPrint("UPDATE");
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(_firebaseAuth.currentUser!.uid.toString())
                            .collection("products")
                            .doc(documentSnapshot!.id)
                            .update({"name": name, "price": price});
                      }
                    }
                    _nameController.text = '';
                    _valueController.text = '';
                    Navigator.of(context).pop();
                  },
                  child: Text(method == "create" ? "Create" : "Update"),
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _products.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  _signOut() async {
    _firebaseAuth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.withOpacity(0.5),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("FIREBASE CRUD"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Center(
                  child: Text(_firebaseAuth.currentUser!.email.toString())),
            ),
            IconButton(
                onPressed: () async {
                  await _signOut();
                  if (_firebaseAuth.currentUser == null) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false);
                  }
                },
                icon: const Icon(Icons.keyboard_backspace))
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(unique_id)
              .collection("products")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    elevation: 2,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(
                        documentSnapshot["product_name"],
                      ),
                      subtitle: Text(documentSnapshot["price"].toString()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(children: [
                          IconButton(
                              onPressed: () {
                                _createOrUpdate(documentSnapshot);
                              },
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                _delete(documentSnapshot.id);
                              },
                              icon: const Icon(Icons.delete)),
                        ]),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _createOrUpdate();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    required this.name,
    required TextEditingController nameController,
    required this.textInputType,
  })  : _nameController = nameController,
        super(key: key);

  final String name;
  final TextEditingController _nameController;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name),
          const SizedBox(
            height: 12,
          ),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: Colors.black, style: BorderStyle.none)),
            ),
            keyboardType: textInputType,
          ),
        ],
      ),
    );
  }
}
