import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/charity.dart';

class SingleCharityScreen extends StatelessWidget {
  static const routeName = '/single_charity';

  @override
  Widget build(BuildContext context) {
    final charityId = ModalRoute.of(context)?.settings?.arguments as int;

    final charityData = Provider.of<CharityProvider>(context, listen: false)
        .findById(charityId);

    return Scaffold(
        appBar: AppBar(
          title: Text(charityData.name),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 300,
                width: double.infinity,
                child: Hero(
                  tag: charityData.id,
                  child: Image.network(
                    charityData.standardUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  charityData.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  softWrap: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  charityData.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ));
  }
}
