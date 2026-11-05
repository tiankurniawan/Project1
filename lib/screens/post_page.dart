import 'package:flutter/material.dart';

import 'post_detail_page.dart';
import '../models/post.dart';
import '../services/api_services.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final ApiService api = ApiService();
  late Future<List<Post>> futurePosts;
  bool _mengirim = false; // status tombol saat POST berjalan

  final TextEditingController _titleController =
    TextEditingController();

  final TextEditingController _bodyController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    futurePosts = api.fetchPosts(); // GET sekali saja
  }
  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  // POST: mengirim data baru ke API
  
Future<void> kirimLaporan() async {
  if (_titleController.text.isEmpty ||
      _bodyController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Judul dan isi laporan harus diisi!'),
      ),
    );
    return;
  }

  setState(() => _mengirim = true);

  try {
    final hasil = await api.createPost(
      _titleController.text,
      _bodyController.text,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Berhasil! ID baru: ${hasil.id}'),
      ),
    );

    _titleController.clear();
    _bodyController.clear();

  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal mengirim: $e')),
    );

  } finally {
    if (mounted) {
      setState(() => _mengirim = false);
    }
  }
}


  @override
  Widget build(BuildContext context) {
    // tanpa Scaffold: AppBar sudah ada di main_navigation.dart
    return Column(
      children: [
        // Form input laporan dan tombol POST
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Laporan',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: _bodyController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Isi Laporan',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _mengirim ? null : kirimLaporan,
                  icon: _mengirim
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  label: Text(
                    _mengirim ? 'Mengirim...' : 'Kirim Laporan',
                  ),
                ),
              ),
            ],
          ),
        ),

        // daftar data hasil GET
        Expanded(
          child: FutureBuilder<List<Post>>(
            future: futurePosts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Data kosong'));
              }

              final posts = snapshot.data!;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (c, i) => Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${posts[i].id}')),
                    title: Text(posts[i].title),
                    subtitle: Text(
                      posts[i].body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailPage(
                            post: posts[i],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
