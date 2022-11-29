import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/charity.dart';
import '../widgets/charity_list_tile_item.dart';

import '../enums/data_state.dart';

class CharityListScreen extends StatefulWidget {
  @override
  State<CharityListScreen> createState() => _CharityListScreenState();
}

class _CharityListScreenState extends State<CharityListScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = new ScrollController();
  bool _isLoading = false;
  bool _isLoadingMore = false;
  late DataState _dataState;
  late Future<void> _listCharities;

  Future<void> _loadCharities(BuildContext context) async {
    print('LOAD CHARITIES');
    loadingAnimation(true);
    await Provider.of<CharityProvider>(context, listen: false)
        .listCharities(loadMore: false);
    loadingAnimation(false);
  }

  Future<void> _clearSearch(BuildContext context) async {
    print('CLEAR SEARCH CHARITIES');
    loadingAnimation(true);
    await Provider.of<CharityProvider>(context, listen: false)
        .listCharities(loadMore: false, clearSearch: true);
    loadingAnimation(false);
  }

  Future<void> _refreshCharities(BuildContext context) async {
    print('REFRESH CHARITIES');
    loadingAnimation(true);
    if (_controller.text.isEmpty) {
      await Provider.of<CharityProvider>(context, listen: false)
          .listCharities(isRefresh: true);
    } else {
      await Provider.of<CharityProvider>(context, listen: false)
          .searchCharities(query: _controller.text, isRefresh: true);
    }
    loadingAnimation(false);
  }

  Future<void> _searchCharities(BuildContext context, String value) async {
    print('SEARCH CHARITIES');
    loadingAnimation(true);
    await Provider.of<CharityProvider>(context, listen: false)
        .searchCharities(query: value, isRefresh: true);
    loadingAnimation(false);
  }

  bool _scrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (_scrollController.position.maxScrollExtent >
              _scrollController.offset &&
          _scrollController.position.maxScrollExtent -
                  _scrollController.offset <=
              50) {
        _isLoadingMore = true;
        print('LOAD MORE!');
        setState(() {});
        Provider.of<CharityProvider>(context, listen: false)
            .listCharities(loadMore: true);
        _isLoadingMore = false;
      }
    }
    return true;
  }

  void _clearTextField() async {
    _controller.clear();
    setState(() {
      _listCharities = _clearSearch(context);
    });
  }

  void loadingAnimation(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  void initState() {
    _listCharities = _loadCharities(context);
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
    _dataState = Provider.of<CharityProvider>(context, listen: false).dataState;

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
              _searchCharities(context, value);
              setState(() {});
            },
          ),
          Flexible(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : FutureBuilder(
                    future: _listCharities,
                    builder: (ctx, charityData) => charityData
                                .connectionState ==
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
                                        child:
                                            Text(charityData.error.toString()),
                                      ),
                                    )
                                  : Consumer<CharityProvider>(
                                      builder: (ctx, charityData, child) =>
                                          Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: charityData.items.isEmpty
                                            ? const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 30.0,
                                                      vertical: 0),
                                                  child: Text(
                                                      'No charities found.'),
                                                ),
                                              )
                                            : Column(
                                                children: [
                                                  Expanded(
                                                    child: ListView.builder(
                                                      itemBuilder:
                                                          (ctx, index) =>
                                                              Column(
                                                        children: [
                                                          CharityListTileItem(
                                                            id: charityData
                                                                .items[index]
                                                                .id,
                                                            name: charityData
                                                                .items[index]
                                                                .name,
                                                            thumbUrl:
                                                                charityData
                                                                    .items[
                                                                        index]
                                                                    .thumbUrl,
                                                          ),
                                                          Divider()
                                                        ],
                                                      ),
                                                      controller:
                                                          _scrollController,
                                                      itemCount: charityData
                                                          .items.length,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                            ),
                          ),
                  ),
          ),
          // if (_dataState == DataState.MoreFetching)
          if (_isLoadingMore)
            Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
