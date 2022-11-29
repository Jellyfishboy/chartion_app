import 'package:chartion_app/screens/charity_select_donation_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/charity.dart';
import '../providers/charity.dart';

class SingleCharityScreen extends StatefulWidget {
  final dynamic charityData;
  static const routeName = '/single_charity';

  const SingleCharityScreen({required this.charityData});

  @override
  State<SingleCharityScreen> createState() => _SingleCharityScreenState();
}

class _SingleCharityScreenState extends State<SingleCharityScreen> {
  late Future<void> _charityData;

  Future<void> _loadCharity(BuildContext context) async {
    print('LOAD SINGLE CHARITY');
    await Provider.of<CharityProvider>(context)
        .findById(widget.charityData as int);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _charityData = _loadCharity(context);
    super.didChangeDependencies();
  }

  void selectDonationCharity(BuildContext context, int id) {
    // Navigator.of(context).pushNamed(
    //   CharitySelectDonationScreen.routeName,
    //   arguments: id,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(charityData.name),
      // ),
      body: FutureBuilder(
        future: _loadCharity(context),
        builder: (ctx, charityData) => charityData.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : charityData.hasError
                ? Center(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
                      child: Text(charityData.error.toString()),
                    ),
                  )
                : Consumer<CharityProvider>(
                    builder: (ctx, charityData, child) => SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 300,
                            width: double.infinity,
                            child: Hero(
                              tag: charityData.singleItem.id,
                              child: Image.network(
                                charityData.singleItem.standardUrl,
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
                              charityData.singleItem.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
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
                              charityData.singleItem.description,
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                selectDonationCharity(context, charityData.singleItem.id);
                              },
                              child: const Text('Donate Now'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
