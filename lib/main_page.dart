import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';

class MainPage extends StatelessWidget {
  const MainPage() : super();

  @override
  Widget build(BuildContext context) {
    final _headerStyle = TextStyle(color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
    final _contentStyle = TextStyle(color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Exhibiton 〜展示会ポータル〜'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(child:
                  Container(
                    child: Accordion(
                      maxOpenSections: 3,
                      headerPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                      children: [
                        AccordionSection(
                          isOpen: false,
                          leftIcon: Icon(Icons.insights_rounded, color: Colors.white),
                          header: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('HogeHoge EXPO 2022', style: _headerStyle),
                              Container(
                                padding: const EdgeInsets.all(5.0),
                                width: 200,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  child:Text("開催まであと 15日",style: TextStyle(color: Color(0xffffffff))),
                                ),
                              ),
                            ],
                          ),
                          content: Column(
                            children: [
                              TextButton(onPressed: (){

                              }, child: Text('1234EXPO 2022春', style: _contentStyle)),
                              TextButton(onPressed: (){

                              }, child: Text('5678展示会 2022', style: _contentStyle)),
                            ],
                          ),
                          contentHorizontalPadding: 20,
                          contentBorderWidth: 1,
                        ),
                      ],
                    ),
                  )
                  ),
                  Container(
                    width: 50,
                  ),
                ],
              ),
              Container(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 50,
                      ),
                      Container(
                        height: 100,
                        width: 200,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.ballot_outlined,
                            color: Colors.white,
                          ),
                          label: const Text('展示品管理'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 200,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.airport_shuttle,
                            color: Colors.white,
                          ),
                          label: const Text('移動指示'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        width: 50,
                      ),
                    ],
                  )
              ),Container(
                height: 50,
              ),],
          ),
        ),
      ),
    );
  }
}