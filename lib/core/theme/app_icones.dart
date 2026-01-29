import 'package:flutter/widgets.dart';

class AppIcones {
  AppIcones._();

  static const _kFontFam = 'AppIcons';
  static const String? _kFontPkg = null;
  
  /* ICONES SVG */
  //LOGOS
  static const logo = "assets/icones/logo.svg";
  //UNIFORMES
  static const uniforme = "assets/icones/kits/uniforme.svg";
  //EMBLEMAS
  static const Map<String, String> emblemas = {
    "emblema_1": "assets/icones/emblemas/emblema_1.svg",
    "emblema_2": "assets/icones/emblemas/emblema_2.svg",
    "emblema_3": "assets/icones/emblemas/emblema_3.svg",
    "emblema_4": "assets/icones/emblemas/emblema_4.svg",
    "emblema_5": "assets/icones/emblemas/emblema_5.svg",
    "emblema_6": "assets/icones/emblemas/emblema_6.svg",
    "emblema_7": "assets/icones/emblemas/emblema_7.svg",
    "emblema_8": "assets/icones/emblemas/emblema_8.svg",
  };
  //CHUTEIRAS
  static const Map<String, String> chuteiras = {
    "futsal": "assets/icones/chuteiras/futsal.svg",
    "society": "assets/icones/chuteiras/society.svg",
    "campo": "assets/icones/chuteiras/campo.svg",
  };
  //SILHUETA DE POSIÇÕES
  static const Map<String, String> silhueta = {
    "ata": "assets/icones/posicoes/silhueta_ata.svg",
    "mei": "assets/icones/posicoes/silhueta_mei.svg",
    "zag": "assets/icones/posicoes/silhueta_zag.svg",
    "gol": "assets/icones/posicoes/silhueta_gol.svg",
  };
  //POSIÇÕES
  static const Map<String, String> posicao = {
    "ata": "assets/icones/posicoes/posicao_ata.svg",
    "mei": "assets/icones/posicoes/posicao_mei.svg",
    "zag": "assets/icones/posicoes/posicao_zag.svg",
    "gol": "assets/icones/posicoes/posicao_gol.svg",
    "cap": "assets/icones/posicoes/posicao_cap.svg",
  };
  //REDES SOCIAIS
  static const String facebook = "assets/icones/facebook.svg";
  static const String google = "assets/icones/google.svg";
  //APPS MAPAS/TRANSPORTE
  static const String google_map = "assets/icones/google_map.svg";
  static const String apple_map = "assets/icones/apple_map.svg";
  static const String uber = "assets/icones/uber.svg";
  static const String ninetyNine= "assets/icones/99.svg";
  static const String waze = "assets/icones/waze.svg";
  static const String moovit = "assets/icones/moovit.svg";
  //LINHAS CAMPO
  static const String futebol_sm = "assets/icones/linhas/futebol_sm.svg";
  static const String futebol_xl = "assets/icones/linhas/futebol_xl.svg";
  static const String fut7_sm = "assets/icones/linhas/fut7_sm.svg";
  static const String fut7_xl = "assets/icones/linhas/fut7_xl.svg";
  static const String futsal_sm = "assets/icones/linhas/futsal_sm.svg";
  static const String futsal_xl = "assets/icones/linhas/futsal_xl.svg";
  static const String volei_sm = "assets/icones/linhas/volei_sm.svg";
  static const String volei_xl = "assets/icones/linhas/volei_xl.svg";
  static const String volei_areia_sm = "assets/icones/linhas/volei_areia_sm.svg";
  static const String volei_areia_xl = "assets/icones/linhas/volei_areia_xl.svg";
  static const String basquete_sm = "assets/icones/linhas/basquete_sm.svg";
  static const String basquete_xl = "assets/icones/linhas/basquete_xl.svg";
  static const String basquete_street_sm = "assets/icones/linhas/basquete_street_sm.svg";
  static const String basquete_street_xl = "assets/icones/linhas/basquete_street_xl.svg";

  /* CUSTOM ICONE */
  static const IconData apito = IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData archive_outline = IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData archive_solid = IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData ball_solid = IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData ban_outline = IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData ban_solid = IconData(0xe805, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bars_outline = IconData(0xe806, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bars_solid = IconData(0xe807, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData basquete_ball_outline = IconData(0xe808, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData basquete_ball_solid = IconData(0xe809, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bell_outline = IconData(0xe80a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bell_slash_outline = IconData(0xe80b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bell_slash_solid = IconData(0xe80c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bell_solid = IconData(0xe80d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData book_outline = IconData(0xe80e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData book_solid = IconData(0xe80f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bookmark_outline = IconData(0xe810, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bookmark_solid = IconData(0xe811, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bullhorn_outline = IconData(0xe812, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bullhorn_solid = IconData(0xe813, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData calculator_outline = IconData(0xe814, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData calculator_solid = IconData(0xe815, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData calendar_check_outline = IconData(0xe816, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData calendar_check_solid = IconData(0xe817, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData calendar_outline = IconData(0xe818, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData calendar_solid = IconData(0xe819, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData calendar_times_outline = IconData(0xe81a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData calendar_times_solid = IconData(0xe81b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData camera_outline = IconData(0xe81c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData camera_solid = IconData(0xe81d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData car_outline = IconData(0xe81e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData car_solid = IconData(0xe81f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData card_outline = IconData(0xe820, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData card_solid = IconData(0xe821, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData chart_line_outline = IconData(0xe822, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData chart_line_solid = IconData(0xe823, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData check_circle_outline = IconData(0xe824, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData check_circle_solid = IconData(0xe825, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData check_outline = IconData(0xe826, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData check_solid = IconData(0xe827, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData clipboard_outline = IconData(0xe828, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData clipboard_solid = IconData(0xe829, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData clock_outline = IconData(0xe82a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData clock_solid = IconData(0xe82b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cog_outline = IconData(0xe82c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cog_solid = IconData(0xe82d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData compass_outline = IconData(0xe82e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData compass_solid = IconData(0xe82f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData crosshairs_outline = IconData(0xe830, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData crosshairs_solid = IconData(0xe831, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData crown_outline = IconData(0xe832, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData crown_solid = IconData(0xe833, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData directions_outline = IconData(0xe834, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData door_close_outline = IconData(0xe835, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData directions_solid = IconData(0xe836, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData door_close_solid = IconData(0xe837, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData door_open_outline = IconData(0xe838, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData door_open_solid = IconData(0xe839, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData edit_outline = IconData(0xe83a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData edit_solid = IconData(0xe83b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData escalacao_outline = IconData(0xe83c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData escalacao_solid = IconData(0xe83d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData exclamation_circle_outline = IconData(0xe83e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData exclamation_circle_solid = IconData(0xe83f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData exclamation_outline = IconData(0xe840, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData exclamation_solid = IconData(0xe841, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData eye_outline = IconData(0xe842, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData eye_slash_outline = IconData(0xe843, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData eye_slash_solid = IconData(0xe844, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData female_outline = IconData(0xe845, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData eye_solid = IconData(0xe846, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData female_solid = IconData(0xe847, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData filter_outline = IconData(0xe848, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData filter_solid = IconData(0xe849, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData fixed_outline = IconData(0xe84a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData fixed_solid = IconData(0xe84b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData foot_futebol_outline = IconData(0xe84c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData foot_futebol_solid = IconData(0xe84d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData foot_fut7_outline = IconData(0xe854, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData foot_fut7_solid = IconData(0xe855, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData foot_futsal_outline = IconData(0xe84e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData foot_futsal_solid = IconData(0xe84f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData foot_left_outline = IconData(0xe850, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData foot_right_outline = IconData(0xe851, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData foot_left_solid = IconData(0xe852, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData foot_right_solid = IconData(0xe853, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData futbol_ball_outline = IconData(0xe856, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData futebol_ball_solid = IconData(0xe857, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData globe_outline = IconData(0xe858, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData globe_solid = IconData(0xe859, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData handshake_outline = IconData(0xe85a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData handshake_solid = IconData(0xe85b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData heart_solid = IconData(0xe85c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData heart_outline = IconData(0xe85d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData history_outline = IconData(0xe85e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData history_solid = IconData(0xe85f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData home_solid = IconData(0xe860, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData home_outline = IconData(0xe861, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData id_card_outline = IconData(0xe862, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData id_card_solid = IconData(0xe863, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData image_outline = IconData(0xe864, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData image_solid = IconData(0xe865, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData instagram_outline = IconData(0xe866, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData instagram_solid = IconData(0xe867, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData life_ring_outline = IconData(0xe868, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData life_ring_solid = IconData(0xe869, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData lock_outline = IconData(0xe86a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData lock_solid = IconData(0xe86b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData male_outline = IconData(0xe86c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData male_solid = IconData(0xe86d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData map_marked_outline = IconData(0xe86e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData map_marked_solid = IconData(0xe86f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData marker_outline = IconData(0xe870, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData marker_solid = IconData(0xe871, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData medal_outline = IconData(0xe872, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData medal_solid = IconData(0xe873, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData minus_outline = IconData(0xe874, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData minus_solid = IconData(0xe875, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData modality_outline = IconData(0xe876, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData modality_solid = IconData(0xe877, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData money_check_outline = IconData(0xe878, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData money_check_solid = IconData(0xe879, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData moon_outline = IconData(0xe87a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData moon_solid = IconData(0xe87b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData paper_plane_outline = IconData(0xe87c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData paper_plane_solid = IconData(0xe87d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData pen_outline = IconData(0xe87e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData pen_solid = IconData(0xe87f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData question_circle_outline = IconData(0xe880, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData question_circle_solid = IconData(0xe881, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData question_outline = IconData(0xe882, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData question_solid = IconData(0xe883, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData save_outline = IconData(0xe884, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData save_solid = IconData(0xe885, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData search_outline = IconData(0xe886, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData search_solid = IconData(0xe887, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData share_outline = IconData(0xe888, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData share_solid = IconData(0xe889, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData shield_outline = IconData(0xe88a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData shield_solid = IconData(0xe88b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData shoe_print_outline = IconData(0xe88c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData shoe_print_solid = IconData(0xe88d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData shopping_cart_outline = IconData(0xe88e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData shopping_cart_solid = IconData(0xe88f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData sign_out_outline = IconData(0xe890, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData sign_out_solid = IconData(0xe891, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData sliders_outline = IconData(0xe892, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData sliders_solid = IconData(0xe893, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData sort_amount_down_outline = IconData(0xe894, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData sort_amount_down_solid = IconData(0xe895, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData sort_amount_up_outline = IconData(0xe896, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData sort_amount_up_solid = IconData(0xe897, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData star_half_outline = IconData(0xe898, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData star_half_solid = IconData(0xe899, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData star_outline = IconData(0xe89a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData star_solid = IconData(0xe89b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData stopwatch_outline = IconData(0xe89c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData stopwatch_solid = IconData(0xe89d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData sun_outline = IconData(0xe89e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData sun_solid = IconData(0xe89f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData task_outline = IconData(0xe8a0, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData task_solid = IconData(0xe8a1, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData times_circle_outline = IconData(0xe8a2, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData times_circle_solid = IconData(0xe8a3, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData times_outline = IconData(0xe8a4, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData times_solid = IconData(0xe8a5, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData trash_outline = IconData(0xe8a6, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData trash_solid = IconData(0xe8a7, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData trophy_outline = IconData(0xe8a8, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData trophy_solid = IconData(0xe8a9, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData unlock_outline = IconData(0xe8aa, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData unlock_solid = IconData(0xe8ab, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_checked_outline = IconData(0xe8ac, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_checked_solid = IconData(0xe8ad, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_clock_outline = IconData(0xe8ae, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_clock_solid = IconData(0xe8af, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_cog_outline = IconData(0xe8b0, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_cog_solid = IconData(0xe8b1, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_edit_outline = IconData(0xe8b2, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_edit_solid = IconData(0xe8b3, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_outline = IconData(0xe8b4, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_plus_outline = IconData(0xe8b5, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_plus_solid = IconData(0xe8b6, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_shield_outline = IconData(0xe8b7, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_shield_solid = IconData(0xe8b8, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_solid = IconData(0xe8b9, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_tie_outline = IconData(0xe8ba, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_tie_solid = IconData(0xe8bb, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_times_outline = IconData(0xe8bc, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_times_solid = IconData(0xe8bd, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData users_outline = IconData(0xe8be, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData users_solid = IconData(0xe8bf, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData volei_ball_outline = IconData(0xe8c0, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData volei_ball_solid = IconData(0xe8c1, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData walk_outline = IconData(0xe8c2, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData walk_solid = IconData(0xe8c3, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}