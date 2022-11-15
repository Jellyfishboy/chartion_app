import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/charity.dart';
import '../widgets/charity_list_tile.dart';

class CharityListScreen extends StatefulWidget {
  @override
  State<CharityListScreen> createState() => _CharityListScreenState();
}

class _CharityListScreenState extends State<CharityListScreen> {
  var _initState = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initState) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<CharityProvider>(context).listCharities().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _initState = false;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chartion')),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CharityListTile(),
    );
  }
}
