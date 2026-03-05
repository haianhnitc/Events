import 'package:events_app/feature/home/presentation/widget/header_home_page.dart';
import 'package:events_app/feature/home/presentation/widget/ranking_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 240,
                decoration: const BoxDecoration(
                    color: Color(0xff00B8DB),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24))),
              ),
            ],
          ),
          SafeArea(
              child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                HeaderHomePage(),
                const SizedBox(height: 24),
                _buildTwoItemSubHEader(),
                const SizedBox(height: 24),
                RankingCard()
              ],
            ).marginSymmetric(horizontal: 16, vertical: 24),
          ))
        ],
      ),
    );
  }

  _buildTwoItemSubHEader() => Row(
        children: [
          _buildEventActionCard(true, null),
          const SizedBox(width: 12),
          _buildEventActionCard(false, null),
        ],
      );

  _buildEventActionCard(bool isEvent, void Function()? onTap) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
              padding: const EdgeInsets.only(top: 16),
              height: 116,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white.withValues(alpha: 0.1),
                        spreadRadius: -1,
                        blurRadius: 6,
                        offset: const Offset(0, 4))
                  ],
                  gradient: isEvent
                      ? LinearGradient(colors: [
                          const Color(0xff06B6D4).withValues(alpha: 0.1),
                          const Color(0xff00B8DB).withValues(alpha: 0.1)
                        ])
                      : LinearGradient(colors: [
                          const Color(0xffDB0025).withValues(alpha: 0.1),
                          const Color(0xffFF6900).withValues(alpha: 0.1)
                        ]),
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                        color: isEvent
                            ? const Color(0xff06B6D4).withValues(alpha: 0.2)
                            : const Color(0xffDB0025).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(57384700)),
                    child: Center(
                      child: isEvent
                          ? const Icon(
                              Icons.calendar_today,
                              size: 24,
                              color: Color(0xff06B6D4),
                            )
                          : const Icon(
                              Icons.people_alt_outlined,
                              size: 28,
                              color: Color(0xffDB0025),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isEvent ? 'Khám phá sự kiện' : 'Việc làm CTV',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        height: 20 / 14,
                        fontWeight: FontWeight.w600),
                  )
                ],
              )),
        ),
      );
}
