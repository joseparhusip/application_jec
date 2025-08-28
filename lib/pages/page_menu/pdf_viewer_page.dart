// lib/pages/pdf_viewer_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class PDFViewerPage extends StatefulWidget {
  final String pdfPath;
  final String title;

  const PDFViewerPage({
    super.key,
    required this.pdfPath,
    required this.title,
  });

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  PDFViewController? _pdfViewController;
  int currentPageNumber = 1;
  int totalPageCount = 0;
  bool isLoading = true;
  bool hasError = false;
  String? localFilePath;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadPDF();
  }

  Future<void> _loadPDF() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      // Copy asset PDF to temporary directory
      final ByteData data = await rootBundle.load(widget.pdfPath);
      final Directory tempDir = await getTemporaryDirectory();
      final String fileName = widget.pdfPath.split('/').last;
      final File file = File('${tempDir.path}/$fileName');
      
      await file.writeAsBytes(data.buffer.asUint8List());
      
      setState(() {
        localFilePath = file.path;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = 'Gagal memuat PDF: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        actions: [
          if (totalPageCount > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$currentPageNumber / $totalPageCount',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (_pdfViewController != null) {
                switch (value) {
                  case 'zoom_in':
                    // Flutter PDFView doesn't have direct zoom control
                    // You can implement custom zoom if needed
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gunakan gesture pinch untuk zoom')),
                    );
                    break;
                  case 'zoom_out':
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gunakan gesture pinch untuk zoom')),
                    );
                    break;
                  case 'fit_width':
                    // Reset to first page as a "fit" alternative
                    await _pdfViewController!.setPage(0);
                    break;
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'zoom_in',
                child: Row(
                  children: [
                    Icon(Icons.zoom_in),
                    SizedBox(width: 8),
                    Text('Perbesar'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'zoom_out',
                child: Row(
                  children: [
                    Icon(Icons.zoom_out),
                    SizedBox(width: 8),
                    Text('Perkecil'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'fit_width',
                child: Row(
                  children: [
                    Icon(Icons.fit_screen),
                    SizedBox(width: 8),
                    Text('Sesuaikan'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          if (hasError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal Memuat PDF',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadPDF,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            )
          else if (localFilePath != null)
            PDFView(
              filePath: localFilePath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              defaultPage: currentPageNumber - 1,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation: false,
              onRender: (pages) {
                setState(() {
                  totalPageCount = pages ?? 0;
                  isLoading = false;
                });
              },
              onError: (error) {
                setState(() {
                  hasError = true;
                  isLoading = false;
                  errorMessage = error.toString();
                });
              },
              onPageError: (page, error) {
                setState(() {
                  hasError = true;
                  isLoading = false;
                  errorMessage = 'Error pada halaman $page: $error';
                });
              },
              onViewCreated: (PDFViewController pdfViewController) {
                _pdfViewController = pdfViewController;
              },
              onLinkHandler: (uri) {
                // Handle link clicks if needed
              },
              onPageChanged: (int? page, int? total) {
                setState(() {
                  currentPageNumber = (page ?? 0) + 1;
                  totalPageCount = total ?? 0;
                });
              },
            ),
          if (isLoading)
            Container(
              color: Colors.white.withValues(alpha: 0.8),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Memuat PDF...'),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: totalPageCount > 0 ? Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Tombol Previous Page
          FloatingActionButton(
            mini: true,
            heroTag: "prev",
            onPressed: currentPageNumber > 1
                ? () async {
                    if (_pdfViewController != null) {
                      await _pdfViewController!.setPage(currentPageNumber - 2);
                    }
                  }
                : null,
            backgroundColor: currentPageNumber > 1 
                ? colorScheme.primary 
                : Colors.grey,
            child: const Icon(Icons.keyboard_arrow_up),
          ),
          const SizedBox(height: 8),
          // Tombol Next Page
          FloatingActionButton(
            mini: true,
            heroTag: "next",
            onPressed: currentPageNumber < totalPageCount
                ? () async {
                    if (_pdfViewController != null) {
                      await _pdfViewController!.setPage(currentPageNumber);
                    }
                  }
                : null,
            backgroundColor: currentPageNumber < totalPageCount 
                ? colorScheme.primary 
                : Colors.grey,
            child: const Icon(Icons.keyboard_arrow_down),
          ),
        ],
      ) : null,
    );
  }

  @override
  void dispose() {
    // Clean up temporary file if needed
    if (localFilePath != null) {
      try {
        File(localFilePath!).deleteSync();
      } catch (e) {
        // Ignore cleanup errors
      }
    }
    super.dispose();
  }
}