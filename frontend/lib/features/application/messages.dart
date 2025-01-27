import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/services/application.dart';
import 'package:flutter_application_1/core/token.dart';
import 'package:flutter_application_1/main.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../core/api/chopper.dart';

final StreamController<Map> messagesStreamController =
    StreamController<Map>.broadcast();

class AplicationMessagesList extends StatefulWidget {
  final String applicationId;

  const AplicationMessagesList({
    super.key,
    required this.applicationId,
  });

  @override
  State<AplicationMessagesList> createState() => _AplicationMessagesListState();
}

class _AplicationMessagesListState extends State<AplicationMessagesList> {
  final PagingController<int, Map> _pagingController = PagingController(
    firstPageKey: 1,
  );

  bool _isLoading = true;
  int? _applicationAuthorId;
  int? _lastKnownTotalItems;
  Timer? _updateTimer;
  StreamSubscription<Map>? _messagesSubscription;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _fetchApplicationInfo();
    _messagesSubscription = messagesStreamController.stream.listen((event) {
      // _pagingController.itemList?.add(event);
      if (_lastKnownTotalItems != null) {
        _lastKnownTotalItems = _lastKnownTotalItems! + 1;
      }
      _pagingController.refresh();
    });

    _updateTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _checkForUpdates(),
    );
  }

  Future<void> _fetchPage(int pageKey) async {
    final service = api.getService<ApplicationService>();

    try {
      final response = await service.viewPage(
        int.tryParse(widget.applicationId) ?? -1,
        pageKey,
      );

      final data = Map<String, dynamic>.from(response.body);

      if (data["is_last_page"]) {
        _pagingController.appendLastPage(List<Map>.from(data["items"]));
        return;
      }

      _pagingController.appendPage(List<Map>.from(data["items"]), pageKey + 1);
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _fetchApplicationInfo() async {
    final service = api.getService<ApplicationService>();

    try {
      final response = await service.view(
        int.tryParse(widget.applicationId) ?? -1,
      );

      final data = Map<String, dynamic>.from(response.body);

      _applicationAuthorId = data["author"];
      _lastKnownTotalItems = data["total_attachments"];
      _isLoading = false;
      setState(() {});
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _checkForUpdates() async {
    final service = api.getService<ApplicationService>();

    try {
      final response = await service.view(
        int.tryParse(widget.applicationId) ?? -1,
      );

      final data = Map<String, dynamic>.from(response.body);

      final currentTotalAttachemnts = data["total_attachments"];

      if (currentTotalAttachemnts != _lastKnownTotalItems) {
        _lastKnownTotalItems = currentTotalAttachemnts;
        _pagingController.refresh();
      }

      setState(() {});
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: PagedListView<int, Map>(
        pagingController: _pagingController,
        padding: const EdgeInsets.all(16),
        reverse: true,
        builderDelegate: PagedChildBuilderDelegate<Map>(
          animateTransitions: true,
          noItemsFoundIndicatorBuilder: (context) => Center(
            child: Text(
              "В этой заявке пока нет сообщений",
            ),
          ),
          itemBuilder: (context, item, index) => Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: switch (item["type"]) {
              "text" => Align(
                  alignment: item["author"] == _applicationAuthorId
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(
                      maxWidth: maxAppWidth * 0.7,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      item["text"],
                    ),
                  ),
                ),
              "info" => Center(child: Text(item["info"])),
              // "file" => CachedNetworkImage(
              //     cacheKey: null,
              //     useOldImageOnUrlChange: false,
              //     imageUrl: "${api.baseUrl}/application/file/${item['id']}",
              //     httpHeaders: {
              //       "Authorization":
              //           "Bearer ${tokenService.getToken() ?? ""}", // or just token depending on your API
              //     },
              //   ),
              "file" => Align(
                  alignment: item["author"] == _applicationAuthorId
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(
                      maxWidth: maxAppWidth * 0.7,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      "${api.baseUrl}/application/file/${item['id']}",
                      headers: {
                        "auth": tokenService.getToken() ?? "",
                      },
                    ),
                  ),
                ),
              _ => const SizedBox(),
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _messagesSubscription?.cancel();
    _updateTimer?.cancel();
    super.dispose();
  }
}
