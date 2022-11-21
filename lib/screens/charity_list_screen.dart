import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/charity.dart';
import '../widgets/charity_list_tile_item.dart';

class CharityListScreen extends StatefulWidget {
  @override
  State<CharityListScreen> createState() => _CharityListScreenState();
}

class _CharityListScreenState extends State<CharityListScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _refreshCharities(BuildContext context) async {
    // since the function is async we can set an await
    if (_controller.text.isEmpty) {
      await Provider.of<CharityProvider>(context, listen: false).listCharities();
    } else {
      await Provider.of<CharityProvider>(context, listen: false).searchCharities(_controller.text);
    }
  }

  // Future<void> _searchCharities(BuildContext context, String query) async {
  //   await Provider.of<CharityProvider>(context, listen: false)
  //       .searchCharities(query);
  // }

  void _clearTextField() {
    _controller.clear();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chartion')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4.0),
                ),
              ),
              suffixIcon: _controller.text.isEmpty
                  ? null // Show nothing if the text field is empty
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _clearTextField,
                    ),
            ),
            onSubmitted: (value) {
              print(value);
              // _searchCharities(context, value);
              setState(() {});
            },
          ),
          Flexible(
              child: FutureBuilder(
            future: _refreshCharities(context),
            builder: (ctx, productData) =>
                productData.connectionState == ConnectionState.waiting
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _refreshCharities(context),
                        child: Consumer<CharityProvider>(
                          builder: (ctx, charityData, child) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemBuilder: (ctx, index) => Column(
                                children: [
                                  CharityListTileItem(
                                    id: charityData.items[index].id,
                                    name: charityData.items[index].name,
                                    thumbUrl: charityData.items[index].thumbUrl,
                                  ),
                                  Divider()
                                ],
                              ),
                              itemCount: charityData.items.length,
                            ),
                          ),
                        ),
                      ),
          ))
        ],
      ),
    );
  }
}
