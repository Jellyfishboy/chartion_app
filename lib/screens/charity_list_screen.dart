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
  final ScrollController _scrollController = new ScrollController();
  bool _isLoading = false;
  bool _loadMore = false;

  Future<void> _loadCharities(BuildContext context) async {
    // since the function is async we can set an await
    if (_controller.text.isEmpty) {
      await Provider.of<CharityProvider>(context, listen: false)
          .listCharities(loadMore: _loadMore);
    } else {
      await Provider.of<CharityProvider>(context, listen: false)
          .searchCharities(query: _controller.text, loadMore: _loadMore);
    }
  }

  Future<void> _refreshCharities(BuildContext context) async {
    // since the function is async we can set an await
    if (_controller.text.isEmpty) {
      await Provider.of<CharityProvider>(context, listen: false)
          .listCharities(isRefresh: true);
    } else {
      await Provider.of<CharityProvider>(context, listen: false)
          .searchCharities(query: _controller.text, isRefresh: true);
    }
  }

  bool _scrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (_scrollController.position.maxScrollExtent >
              _scrollController.offset &&
          _scrollController.position.maxScrollExtent -
                  _scrollController.offset <=
              50) {
        _isLoading = true;
        print('LOAD MORE!');
        _isLoading = false;
        // setState(() {});
        Provider.of<CharityProvider>(context, listen: false).listCharities(loadMore: true);
      }
    }
    return true;
  }

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
    _scrollController.dispose();
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
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(
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
              future: _loadCharities(context),
              builder: (ctx, charityData) => charityData.connectionState ==
                      ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: _scrollNotification,
                      child: RefreshIndicator(
                        onRefresh: () => _refreshCharities(context),
                        child: charityData.hasError
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 0),
                                  child: Text(charityData.error.toString()),
                                ),
                              )
                            : Consumer<CharityProvider>(
                                builder: (ctx, charityData, child) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: charityData.items.isEmpty
                                      ? const Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 30.0, vertical: 0),
                                            child: Text('No charities found.'),
                                          ),
                                        )
                                      : Column(
                                          children: [
                                            Text(
                                                "Total Results: ${charityData.totalResults.toString()}"),
                                            Text(
                                                "Per Page: ${charityData.perPage.toString()}"),
                                            Text(
                                                "Total Pages: ${charityData.totalPages.toString()}"),
                                            Text(
                                                "Current Page: ${charityData.currentPage.toString()}"),
                                            Expanded(
                                              child: ListView.builder(
                                                itemBuilder: (ctx, index) =>
                                                    Column(
                                                  children: [
                                                    CharityListTileItem(
                                                      id: charityData
                                                          .items[index].id,
                                                      name: charityData
                                                          .items[index].name,
                                                      thumbUrl: charityData
                                                          .items[index]
                                                          .thumbUrl,
                                                    ),
                                                    Divider()
                                                  ],
                                                ),
                                                controller: _scrollController,
                                                itemCount:
                                                    charityData.items.length,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
