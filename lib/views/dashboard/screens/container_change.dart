import 'package:flutter/material.dart';

class CategoryListItems extends StatefulWidget {
  const CategoryListItems({Key? key}) : super(key: key);

  @override
  State<CategoryListItems> createState() => _CategoryListItemsState();
}

class _CategoryListItemsState extends State<CategoryListItems>
    with SingleTickerProviderStateMixin {
  double _bottomPosition = -150;
  double opacity = 0.2;
  @override
  Widget build(BuildContext context) {
    String category_selected = "Vegetables";
    Color colorCont = Colors.green;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(245, 131, 33, 1),
          title: TextField(
            decoration: InputDecoration(hintText: "Search for vegetables"),
          )),
      backgroundColor: Color.fromRGBO(255, 251, 247, 1),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(category_selected,
                    style: TextStyle(
                        color: Color.fromRGBO(67, 67, 67, 1),
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Ink(
                          child: Container(
                            color: colorCont,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Center(
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _bottomPosition = 0;
                                        });
                                      },
                                      child: Text("Popup")),
                                ),
                                Center(
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          colorCont = Colors.red;
                                        });
                                      },
                                      child: Text("change color")),
                                ),
                                Center(
                                  child: TextButton(
                                      onPressed: () {
                                        print(colorCont.toString());
                                      },
                                      child: Text("print opacity")),
                                ),
                              ],
                            ),
                          ),
                        ))),
              ],
            ),
          ),
          AnimatedPositioned(
            height: 150,
            child: Container(
              color: Colors.orange,
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _bottomPosition = -70;
                          });
                        },
                        child: Icon(Icons.arrow_back)),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            opacity = 1;
                          });
                          print(opacity);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          color: Colors.red.withOpacity(opacity),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            duration: Duration(milliseconds: 100),
            bottom: _bottomPosition,
          )
        ],
      ),
    );
  }
}
