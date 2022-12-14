import 'dart:html';
import 'main.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';

import 'member_register.dart';
import 'random_string.dart';

// リスト一覧画面用Widget
class EventRegisterPage extends StatefulWidget {
  @override
  _EventRegisterPageState createState() => _EventRegisterPageState();
}

class _EventRegisterPageState extends State<EventRegisterPage> {
  // State
  // イベントの名前
  String EventName = '';
  // イベントの日程
  var EventDate = DateTime.now();

  // エラー文
  var FormExceptionText = "";

  // 日付を入力するフォーム
  _EventDatePicker(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: EventDate,
        firstDate: DateTime(2003),
        lastDate: DateTime(2023));
    if (datePicked != null && datePicked != EventDate) {
      setState(() {
        EventDate = datePicked;
      });
    }
  }

  // 日付のフォーマッター
  DateFormat outputFormat = DateFormat('yyyy/MM/dd');

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;

    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: AppBar(
        title: Text('イベント登録'),
      ),
      // ListViewを使いリスト一覧を表示
      body: SingleChildScrollView(
          child: Column(children: [
        Padding(
            padding: EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
            child: Column(children: [
              Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'イベントの情報を登録しよう',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )),
              Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 10.0,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 32.0, left: 16.0, bottom: 16.0, right: 16.0),
                      child: Column(
                        children: <Widget>[
                          // イベント名の入力フィールド
                          TextFormField(
                            // 自動フォーカス
                            autofocus: true,
                            // テキスト入力のラベルを設定
                            decoration: InputDecoration(
                              labelText: 'イベント名',
                              icon: Icon(
                                Icons.emoji_events,
                              ),
                              hintText: 'イベント名を入力してください',
                              hintStyle: TextStyle(
                                  color: kTextColorSecondary, fontSize: 10),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: kAccentColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: kTextColorSecondary,
                                ),
                              ),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                EventName = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),

                          // 日付の入力ボックス
                          Container(
                            child: InputDecorator(
                              decoration: InputDecoration(
                                icon: Icon(Icons.edit_calendar),
                                border: InputBorder.none,
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'イベントの日程',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: kTextColorSecondary,
                                        ),
                                      ),
                                    ),
                                    child: Text(outputFormat.format(EventDate),
                                        textAlign: TextAlign.left),
                                  ),
                                ),
                                onTap: () {
                                  _EventDatePicker(context);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // イベント登録ボタン
                          ElevatedButton.icon(
                              icon: const Icon(
                                Icons.done,
                                color: Colors.white,
                              ),
                              label: const Text('イベント登録'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                onPrimary: Colors.white,
                                fixedSize: Size.fromHeight(30),
                              ),
                              onPressed: () async {
                                if (EventName != "") {
                                  setState(() {
                                    FormExceptionText = "";
                                  });
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      // 遷移先の画面としてリスト追加画面を指定
                                      return MemberRegisterPage(
                                          EventName: EventName,
                                          EventDate: EventDate);
                                    }),
                                  );
                                } else {
                                  setState(() {
                                    FormExceptionText = "イベント名を入力して下さい";
                                  });
                                }
                              }),

                          // 注意書きのテキスト
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              FormExceptionText,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ))),
            ]))
      ])),
    );
  }
}
