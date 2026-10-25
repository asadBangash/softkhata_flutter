import 'package:flutter/material.dart';

class SliderModel {
  String image;
  String title;
  String subtitle;

  SliderModel({this.image, this.title, this.subtitle});
}

var slider_list = [
  SliderModel(
      image: "images/no_more_reg.png",
      title: "No More Register",
      subtitle:
          "Add your transections into your app no more tension for taking money."),
  SliderModel(
      image: "images/no_more_remember.png",
      title: "No more remember",
      subtitle:
          "No more tension for transection. This app send you a notification on deadline"),
  SliderModel(
      image: "images/save_transaction.png",
      title: "Save Transections in written",
      subtitle:
          "Create transcript for every transections means not more dishonest")
];
