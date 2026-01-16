import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/bible_providers.dart';
import '../../data/book_names.dart';
import '../widgets/header.dart';
import 'chapter_selection_page.dart';
// Connectivity gating removed; keep providers only for data refresh elsewhere

class BibleBrowserPage extends ConsumerStatefulWidget {
  const BibleBrowserPage({super.key});

  @override
  ConsumerState<BibleBrowserPage> createState() => _BibleBrowserPageState();
}

class _BibleBrowserPageState extends ConsumerState<BibleBrowserPage> {
  // Per-page banner removed; global banner is shown in HomePage

  @override
  void initState() {
    super.initState();
    // Run reseed automatically once the page is shown (previously a debug button)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final ds = ref.read(bibleLocalDataSourceProvider);
        await ds.ensureSeededFromAssets(forceRebuild: true, language: ref.read(appLanguageProvider));
        ref.invalidate(getAllBooksProvider);
      } catch (_) {
        // ignore errors here; provider will surface issues if any
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(getAllBooksProvider);
    // Keep watching premium for potential future UI tweaks; not used directly here

    // Premium/online gating removed: Bible list always accessible

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFEF3C7),
                    Colors.white,
                    Color(0xFFFED7AA),
                  ],
                ),
              ),
              child: booksAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, stack) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Color(0xFFB45309),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            ref.watch(appStringsProvider).errorLoadingBible,
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            e.toString(),
                            style: const TextStyle(color: Color(0xFF64748B)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              ref.invalidate(getAllBooksProvider);
                            },
                            child: const Text('Tentar Novamente'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                data: (books) {
                  final topInset = MediaQuery.of(context).padding.top;
                  final double topPad = (topInset + 16) < 64 ? 64.0 : (topInset + 16);
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: RefreshIndicator(
                      triggerMode: RefreshIndicatorTriggerMode.anywhere,
                      displacement: 28,
                      edgeOffset: 0,
                      onRefresh: () async {
                        final ds = ref.read(bibleLocalDataSourceProvider);
                        await ds.ensureSeededFromAssets(forceRebuild: false, language: ref.read(appLanguageProvider));
                        ref.invalidate(getAllBooksProvider);
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: topPad),
                            Header(
                              title: ref.watch(appStringsProvider).bible,
                              subtitle: ref.watch(appStringsProvider).book,
                            ),
                            const SizedBox(height: 24),
                            ...books.map((bookName) {
                              final lang = ref.read(appLanguageProvider);
                              // Try to resolve the book number from the provider's name using
                              // the current app language; if not found, try the other language.
                              int bookNum = getBookNumberByName(bookName, langCode: lang.code);
                              if (bookNum == -1) {
                                final other = lang.code == 'en' ? 'pt' : 'en';
                                bookNum = getBookNumberByName(bookName, langCode: other);
                              }
                              final displayName = bookNum == -1 ? bookName : getBookNameByNumber(bookNum, langCode: lang.code);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      // Ensure local data seeded and refresh chapters provider
                                      final ds = ref.read(bibleLocalDataSourceProvider);
                                      final lang = ref.read(appLanguageProvider);
                                      print('BibleBrowser: tapped book=$bookName lang=${lang.code}');
                                      await ds.ensureSeededFromAssets(forceRebuild: false, language: lang);
                                      // Verify chapters exist for this book; if not, force a reseed and try again
                                      var chapters = await ds.getChaptersByBook(bookName, langCode: lang.code);
                                      if (chapters.isEmpty) {
                                        print('BibleBrowser: chapters empty for $bookName — forcing reseed for ${lang.code}');
                                        await ds.ensureSeededFromAssets(forceRebuild: true, language: lang);
                                        chapters = await ds.getChaptersByBook(bookName, langCode: lang.code);
                                      }
                                      print('BibleBrowser: chapters for $bookName = ${chapters.length}');
                                      ref.invalidate(getChaptersByBookProvider(bookName));

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChapterSelectionPage(bookName: bookName),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFCD34D).withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFFCD34D).withOpacity(0.2),
                                            blurRadius: 12,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            displayName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFFB45309),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                            color: Color(0xFFB45309),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Banner removed here; shown globally in HomePage
        ],
      ),
    );
  }
}
