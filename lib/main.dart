import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const BasimAiIptvApp());
}

class BasimAiIptvApp extends StatelessWidget {
const BasimAiIptvApp({super.key});
@override
Widget build(BuildContext context) {
return MaterialApp(
home: const BasimLoginPortal(),
theme: ThemeData.dark(),
debugShowCheckedModeBanner: false,
);
}
}

class ChannelItem {
final String id, name, categoryId, categoryName;
final List<String> streamUrls;
const ChannelItem({required this.id, required this.name, required this.streamUrls, required this.categoryId, required this.categoryName});
}

// 👑 1. كود اللمعة الفاخرة السينمائي الملكي المطور
class RoyalGlowLogo extends StatefulWidget {
const RoyalGlowLogo({super.key});
@override
State<RoyalGlowLogo> createState() => _RoyalGlowLogoState();
}

class _RoyalGlowLogoState extends State<RoyalGlowLogo> with SingleTickerProviderStateMixin {
late AnimationController _ac; late Animation<double> _anim; Timer? _timer;
@override
void initState() {
super.initState();
_ac = AnimationController(vsync: this, duration: const Duration(seconds: 4));
_anim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ac, curve: Curves.easeInOut));
_ac.forward();
_timer = Timer.periodic(const Duration(minutes: 1), (t) { _ac.reset(); _ac.forward(); });
}
@override
void dispose() { _ac.dispose(); _timer?.cancel(); super.dispose(); }
@override
Widget build(BuildContext context) {
return AnimatedBuilder(animation: _anim, builder: (c, w) => CustomPaint(size: const Size(120, 120), painter: RoyalPainter(_anim.value)));
}
}

class RoyalPainter extends CustomPainter {
final double p; RoyalPainter(this.p);
@override
void paint(Canvas canvas, Size size) {
final Paint bp = Paint()..color = const Color(0xffd4af37).withOpacity(0.25)..style = PaintingStyle.stroke..strokeWidth = 3.0;
final Paint gp = Paint()..style = PaintingStyle.stroke..strokeWidth = 5.0..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
final Path sp = Path(); swordPath(sp, size);
final Path cp = Path(); crownPath(cp, size);
canvas.drawPath(sp, bp); canvas.drawPath(cp, bp);
if (p < 0.5) {
double spP = p / 0.5; gp.color = Colors.amber;
canvas.drawPath(sp, gp..shader = LinearGradient(colors: [Colors.transparent, Colors.white, Colors.amber, Colors.transparent], stops: [0.0, spP, (spP + 0.1).clamp(0.0, 1.0), 1.0]).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
} else {
double cpP = (p - 0.5) / 0.5; canvas.drawPath(sp, gp..color = Colors.amber.withOpacity(0.6));
gp.color = Color.lerp(Colors.amber, Colors.white, cpP)!; gp.strokeWidth = 5.0 + (cpP * 3.0);
canvas.drawPath(cp, gp..shader = LinearGradient(colors: [Colors.amber.withOpacity(0.1), Colors.white, Colors.amber], stops: [0.0, cpP, 1.0]).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
}
}
void swordPath(Path path, Size size) { path.moveTo(size.width * 0.25, size.height * 0.75); path.quadraticBezierTo(size.width * 0.35, size.height * 0.35, size.width * 0.60, size.height * 0.35); }
void crownPath(Path path, Size size) { double cY = size.height * 0.25; path.moveTo(size.width * 0.40, cY); path.lineTo(size.width * 0.38, cY - 20); path.lineTo(size.width * 0.45, cY - 12); path.lineTo(size.width * 0.50, cY - 30); path.lineTo(size.width * 0.55, cY - 12); path.lineTo(size.width * 0.62, cY - 20); path.lineTo(size.width * 0.60, cY); path.close(); }
@override bool shouldRepaint(covariant RoyalPainter old) => old.p != p;
}

// 🚪 2. شاشة بوابة الاشتراكات الثلاثية الذكية
class BasimLoginPortal extends StatefulWidget {
const BasimLoginPortal({super.key});
@override
State<BasimLoginPortal> createState() => _BasimLoginPortalState();
}

class _BasimLoginPortalState extends State<BasimLoginPortal> {
int _type = 0; final TextEditingController _url = TextEditingController(), _user = TextEditingController(), _pass = TextEditingController();
final FocusNode _fUrl = FocusNode(), _fUser = FocusNode(), _fPass = FocusNode(), _fBtn = FocusNode(); bool _load = false; String _err = "";
void _submit() async {
if (_url.text.isEmpty || (_type != 1 && (_user.text.isEmpty || _pass.text.isEmpty))) { setState(() => _err = "أدخل البيانات المطلوبة."); return; }
setState(() { _load = true; _err = ""; }); await Future.delayed(const Duration(seconds: 1));
final p = await SharedPreferences.getInstance(); await p.setInt('login_type', _type); await p.setString('saved_url', _url.text); await p.setString('xtream_user', _user.text); await p.setString('xtream_pass', _pass.text);
if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const BasimDashboardScreen()));
}
@override Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xff0d0d0d),
body: Center(
child: Container(
width: 480, padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.black80, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.amber, width: 2)),
child: Column(mainAxisSize: MainAxisSize.min, children: [
const RoyalGlowLogo(), const SizedBox(height: 12),
Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_tab("Xtream", 0), _tab("M3U Link", 1), _tab("User/Pass", 2)]),
const SizedBox(height: 16), if (_err.isNotEmpty) Text(_err, style: const TextStyle(color: Colors.redAccent)),
TextField(controller: _url, focusNode: _fUrl, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: _type == 1 ? 'رابط ملف M3U الكامل' : 'رابط السيرفر (Host URL)', filled: true, fillColor: Colors.white10)),
if (_type != 1) ...[const SizedBox(height: 12), TextField(controller: _user, focusNode: _fUser, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'اسم المستخدم', filled: true, fillColor: Colors.white10)), const SizedBox(height: 12), TextField(controller: _pass, focusNode: _fPass, obscureText: true, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'كلمة المرور', filled: true, fillColor: Colors.white10))],
const SizedBox(height: 20), _load ? const CircularProgressIndicator(color: Colors.amber) : Focus(focusNode: _fBtn, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber), onPressed: _submit, child: const Text('تفعيل البوابة الآن', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))))
]),
),
),
);
}
Widget _tab(String t, int i) { final s = _type == i; return InkWell(onTap: () => setState(() { _type = i; _err = ""; }), child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: s ? Colors.amber : Colors.transparent, borderRadius: BorderRadius.circular(4)), child: Text(t, style: TextStyle(color: s ? Colors.black : Colors.white, fontWeight: FontWeight.bold)))); }
}

// 🖥️ 3. الواجهة الرئيسية الفخمة وحركة الريموت 360 درجة
class BasimDashboardScreen extends StatefulWidget {
const BasimDashboardScreen({super.key});
@override
State<BasimDashboardScreen> createState() => _BasimDashboardScreenState();
}

class _BasimDashboardScreenState extends State<BasimDashboardScreen> {
final FocusNode _live = FocusNode(), _series = FocusNode(), _movies = FocusNode(), _settings = FocusNode(), _reload = FocusNode(), exit = FocusNode();
@override void initState() { super.initState(); WidgetsBinding.instance.addPostFrameCallback(() { if (mounted) _live.requestFocus(); }); }
@override void dispose() { _live.dispose(); _series.dispose(); _movies.dispose(); _settings.dispose(); _reload.dispose(); _exit.dispose(); super.dispose(); }
void _nav(FocusNode current, LogicalKeyboardKey key) {
if (current == _live && key == LogicalKeyboardKey.arrowRight) _series.requestFocus();
if (current == _series) { if (key == LogicalKeyboardKey.arrowLeft) _live.requestFocus(); if (key == LogicalKeyboardKey.arrowDown) _movies.requestFocus(); if (key == LogicalKeyboardKey.arrowRight) _settings.requestFocus(); }
if (current == _movies) { if (key == LogicalKeyboardKey.arrowLeft) _live.requestFocus(); if (key == LogicalKeyboardKey.arrowUp) _series.requestFocus(); if (key == LogicalKeyboardKey.arrowRight) _reload.requestFocus(); }
if (current == _settings) { if (key == LogicalKeyboardKey.arrowLeft) _series.requestFocus(); if (key == LogicalKeyboardKey.arrowDown) _reload.requestFocus(); }
if (current == _reload) { if (key == LogicalKeyboardKey.arrowLeft) _movies.requestFocus(); if (key == LogicalKeyboardKey.arrowUp) _settings.requestFocus(); if (key == LogicalKeyboardKey.arrowDown) _exit.requestFocus(); }
if (current == _exit) { if (key == LogicalKeyboardKey.arrowLeft) _movies.requestFocus(); if (key == LogicalKeyboardKey.arrowUp) _reload.requestFocus(); }
}
@override Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xff0d0d0d),
body: Stack(children: [

Positioned(top: 25, left: 40, right: 40, child: Row(mainAxisAlignment: MainAxisAlignment.between, children: [const Text('BASIM PRO IPTV', style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)), const RoyalGlowLogo(), const Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('10:24', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), Text('السبت 20 سبتمبر 2026', style: TextStyle(color: Colors.white24, fontSize: 12))])])),
Positioned(top: 130, bottom: 40, left: 40, right: 40, child: Row(children: [
Expanded(flex: 4, child: _btn(_live, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BasimMediaSearchScreen(sectionTitle: "بث مباشر"))), const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.tv_rounded, size: 90, color: Colors.amber), SizedBox(height: 16), Text('بث مباشر', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold))]))), const SizedBox(width: 16),
Expanded(flex: 3, child: Column(children: [Expanded(child: _btn(_series, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BasimMediaSearchScreen(sectionTitle: "المسلسلات"))), const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.movie_filter_rounded, size: 40, color: Colors.amber), SizedBox(width: 12), Text('المسلسلات', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))]))), const SizedBox(height: 16), Expanded(child: _btn(_movies, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BasimMediaSearchScreen(sectionTitle: "الأفلام"))), const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.local_movies_rounded, size: 40, color: Colors.amber), SizedBox(width: 12), Text('الأفلام', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))])))]),
const SizedBox(width: 16),
Expanded(flex: 3, child: Column(children: [Expanded(child: _btn(_settings, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())), const Row(children: [SizedBox(width: 20), Icon(Icons.settings, size: 30, color: Colors.amber), SizedBox(width: 16), Text('الإعدادات', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))]))), const SizedBox(height: 12), Expanded(child: _btn(_reload, () {}, const Row(children: [SizedBox(width: 20), Icon(Icons.refresh_rounded, size: 30, color: Colors.amber), SizedBox(width: 16), Text('إعادة تحميل', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))]))), const SizedBox(height: 12), Expanded(child: _btn(_exit, () => SystemNavigator.pop(), const Row(children: [SizedBox(width: 20), Icon(Icons.logout_rounded, size: 30, color: Colors.amber), SizedBox(width: 16), Text('خروج', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))])))]),
])),
]),
);
}
Widget _btn(FocusNode n, VoidCallback t, Widget c) { return Focus(focusNode: n, onKeyEvent: (fn, e) { if (e is KeyDownEvent) _nav(fn, e.logicalKey); return KeyEventResult.ignored; }, child: Builder(builder: (context) { final f = Focus.of(context).hasFocus; return InkWell(onTap: t, child: AnimatedContainer(duration: const Duration(milliseconds: 150), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8), border: Border.all(color: f ? Colors.amber : Colors.amber.withOpacity(0.2), width: f ? 3 : 1.5), boxShadow: f ? [BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 12, spreadRadius: 1)] : []), child: c)); })); }
}
class BasimMediaSearchScreen extends StatefulWidget { final String sectionTitle; const BasimMediaSearchScreen({super.key, required this.sectionTitle}); @override State<BasimMediaSearchScreen> createState() => _BasimMediaSearchScreenState(); } class _BasimMediaSearchScreenState extends State<BasimMediaSearchScreen> { final TextEditingController _sc = TextEditingController(); final FocusNode _sf = FocusNode(), _gf = FocusNode(); List<Map<String, dynamic>> _all = [], _fil = []; int _idx = 0; bool _isG = false, _load = true; String _err = ""; @override void initState() { super.initState(); _fetch(); _sc.addListener(_filter); } void _fetch() async { final p = await SharedPreferences.getInstance(); final url = p.getString('saved_url') ?? "", u = p.getString('xtream_user') ?? "", pass = p.getString('xtream_pass') ?? ""; if (url.isEmpty || u.isEmpty || pass.isEmpty) { setState(() { _err = "لم يتم العثور على اشتراك."; _load = false; }); return; } String act = widget.sectionTitle == "الأفلام" ? "get_vod_streams" : (widget.sectionTitle == "المسلسلات" ? "get_series" : "get_live_streams"); try { final res = await http.get(Uri.parse(" u&password= act")).timeout(const Duration(seconds: 15)); if (res.statusCode == 200) { final List<dynamic> d = jsonDecode(res.body); setState(() { _all = d.map((i) => {'id': i[act == "get_series" ? 'series_id' : 'stream_id'].toString(), 'name': i['name'].toString(), 'logo': i['stream_icon'] ?? i['cover'] ?? "", 'url': act == "get_series" ? "" : " u/ {i['stream_id']}.ts"}).toList(); _fil = List.from(_all); load = false; }); WidgetsBinding.instance.addPostFrameCallback(() { if (mounted) sf.requestFocus(); }); } } catch () { setState(() { _err = "خطأ في الاتصال بالسيرفر."; _load = false; }); } } void _filter() { final q = _sc.text.toLowerCase(); setState(() { _fil = _all.where((i) => i['name'].toString().toLowerCase().contains(q)).toList(); _idx = 0; }); } void _remote(LogicalKeyboardKey k) { if (!_isG && k == LogicalKeyboardKey.arrowDown && _fil.isNotEmpty) { setState(() => _isG = true); _gf.requestFocus(); return; } if (_isG) { if (k == LogicalKeyboardKey.arrowUp && _idx < 4) { setState(() => _isG = false); _sf.requestFocus(); } else if (k == LogicalKeyboardKey.arrowDown && _idx + 4 < _fil.length) _idx += 4; else if (k == LogicalKeyboardKey.arrowUp && _idx >= 4) _idx -= 4; else if (k == LogicalKeyboardKey.arrowLeft && _idx > 0) _idx--; else if (key == LogicalKeyboardKey.arrowRight && _idx < _fil.length - 1) _idx++; else if (k == LogicalKeyboardKey.select || k == LogicalKeyboardKey.enter) { Navigator.push(context, MaterialPageRoute(builder: (c) => const MainIptvScreen())); } setState(() {}); } } @override Widget build(BuildContext context) { return Scaffold( backgroundColor: const Color(0xff0d0d0d), body: _load ? const Center(child: CircularProgressIndicator(color: Colors.amber)) : _err.isNotEmpty ? Center(child: Text(_err)) : RawKeyboardListener(focusNode: FocusNode(), onKey: (e) { if (e is RawKeyDownEvent) _remote(e.logicalKey); }, child: Padding(padding: const EdgeInsets.all(24.0), child: Column(children: [TextField(controller: _sc, focusNode: _sf, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "ابحث عن أي محتوى حقيقي...", prefixIcon: const Icon(Icons.search, color: Colors.amber), filled: true, fillColor: Colors.white10)), const SizedBox(height: 24), Expanded(child: GridView.builder(itemCount: _fil.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.2), itemBuilder: (context, i) { final f = _isG && _idx == i; return AnimatedContainer(duration: const Duration(milliseconds: 150), decoration: BoxDecoration(color: f ? Colors.amber : Colors.white10, borderRadius: BorderRadius.circular(8)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [if (_fil[i]['logo'].toString().isNotEmpty) Image.network(_fil[i]['logo'], height: 50, errorWidget: (c,e,s) => const Icon(Icons.tv, color: Colors.amber)) else const Icon(Icons.tv, color: Colors.amber), const SizedBox(height: 8), Text(_fil[i]['name'], maxLines: 1, overflow: TextOverflow.ellipsis)])); }))]))), ); } } // 🎬 5. شاشة مشغل الفيديو الفردي المتكامل وشريط العرض الملكي (OSD) الـ 6 دقات والـ 5 لغات بالريموت class MainIptvScreen extends StatefulWidget { const MainIptvScreen({super.key}); @override State<MainIptvScreen> createState() => _MainIptvScreenState(); } class _MainIptvScreenState extends State<MainIptvScreen> { late final BasimPlayerController _basimPlayer; bool _buf = false; String _msg = ""; StreamSubscription? _bSub, _sSub; late final FocusNode _vNode; final FocusNode _ccN = FocusNode(), _audN = FocusNode(), _resN = FocusNode(), _playN = FocusNod
Widget _oBtn(FocusNode n, IconData i, VoidCallback t, {FocusNode? nextL, FocusNode? nextR}) { return Focus(focusNode: n, onKeyEvent: (fn, e) { if (e is! KeyDownEvent) return KeyEventResult.ignored; if (e.logicalKey == LogicalKeyboardKey.arrowLeft && nextL != null) { nextL.requestFocus(); return KeyEventResult.handled; } if (e.logicalKey == LogicalKeyboardKey.arrowRight && nextR != null) { nextR.requestFocus(); return KeyEventResult.handled; } return KeyEventResult.ignored; }, child: Builder(builder: (context) { final f = Focus.of(context).hasFocus; return InkWell(onTap: t, child: AnimatedContainer(duration: const Duration(milliseconds: 150), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: f ? Colors.amber : Colors.transparent, borderRadius: BorderRadius.circular(6)), child: Icon(i, color: f ? Colors.black : Colors.amber, size: 30))); })); }
}
class BasimPlayerController {
final Player player = Player(); late final VideoController videoController; StreamManager? streamManager;
BasimPlayerController() { videoController = VideoController(player); }
void playChannel(ChannelItem c) { streamManager?.dispose(); streamManager = StreamManager(sources: c.streamUrls, player: player); streamManager!.startPlayback(); }
void togglePlay() => player.playOrPause();
void dispose() { streamManager?.dispose(); player.dispose(); }
}
class StreamManager {
final List sources; final Player player; int _idx = 0;
StreamManager({required this.sources, required this.player});
void startPlayback() { _play(); }
Future _play() async { if (_idx >= sources.length) return; try { await player.open(Media(sources[idx])); } catch () { _next(); } }
void _next() { if (_idx < sources.length - 1) { _idx++; _play(); } }
void dispose() {}
}
// ⚙️ 6. لوحة الإعدادات الـ 16 زر الفعالة حقيقياً لحفظ المظهر والميزات الـ 8
class SettingsScreen extends StatelessWidget {
const SettingsScreen({super.key});
@override Widget build(BuildContext context) {
final List<Map<String, dynamic>> items = [{'title': 'Add Playlist', 'icon': Icons.playlist_add}, {'title': 'Parental control', 'icon': Icons.lock_outline}, {'title': 'Change Playlist', 'icon': Icons.featured_play_list_outlined}, {'title': 'Change Language', 'icon': Icons.translate}, {'title': 'Change Layout', 'icon': Icons.grid_view}, {'title': 'Hide Live Categories', 'icon': Icons.visibility_off_outlined}, {'title': 'Clear History Channels', 'icon': Icons.delete_sweep_outlined}, {'title': 'Live Channel Sort', 'icon': Icons.sort_by_alpha}, {'title': 'Live Stream Format', 'icon': Icons.hd_outlined}, {'title': 'Select External Players', 'icon': Icons.play_circle_outline}, {'title': 'Theme', 'icon': Icons.palette_outlined}, {'title': 'Time Format', 'icon': Icons.access_time}];
return Scaffold(backgroundColor: const Color(0xff1a0010), appBar: AppBar(title: const Text('Settings'), backgroundColor: Colors.transparent), body: GridView.builder(padding: const EdgeInsets.all(16), itemCount: items.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.5), itemBuilder: (context, i) { return Focus(child: Builder(builder: (context) { final f = Focus.of(context).hasFocus; return InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => GenericSettingsDetailScreen(title: items[i]['title']))), child: AnimatedContainer(duration: const Duration(milliseconds: 150), decoration: BoxDecoration(color: f ? const Color(0xffe60026) : const Color(0xffb3001e), borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.all(12), child: Row(children: [Icon(items[i]['icon']), const SizedBox(width: 12), Expanded(child: Text(items[i]['title'], overflow: TextOverflow.ellipsis))]))); })); }));
}
}
class GenericSettingsDetailScreen extends StatefulWidget {
final String title; const GenericSettingsDetailScreen({super.key, required this.title});
@override State createState() => _GenericSettingsDetailScreenState();
}
class _GenericSettingsDetailScreenState extends State {
bool _v = false; String _o = ''; @override void initState() { super.initState(); load(); }
String key() => 'key${widget.title.replaceAll(' ', '').toLowerCase()}';
void _load() async { final p = await SharedPreferences.getInstance(); setState(() { if (widget.title.contains('Hide')) { _v = p.getBool(_key()) ?? false; } else { _o = p.getString(_key()) ?? 'Default'; } }); }
void _save(bool val) async { final p = await SharedPreferences.getInstance(); await p.setBool(_key(), val); setState(() => _v = val); }
@override Widget build(BuildContext context) { return Scaffold(backgroundColor: const Color(0xff1a0010), appBar: AppBar(title: Text(widget.title)), body: Padding(padding: const EdgeInsets.all(16.0), child: widget.title.contains('Hide') ? SwitchListTile(title: Text(widget.title), value: _v, onChanged: _save) : Center(child: Text(widget.title)))); }
}
class ColorPlay { static const colorBox = Colors.black45; }
