import 'package:events_app/feature/event_management/presentation/controller/event_page_controller.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:flutter/material.dart';

class EventFilterSheet extends StatefulWidget {
  final EventPageController controller;

  const EventFilterSheet({super.key, required this.controller});

  @override
  State<EventFilterSheet> createState() => _EventFilterSheetState();
}

class _EventFilterSheetState extends State<EventFilterSheet> {
  late Map<String, dynamic> _draft;

  @override
  void initState() {
    super.initState();
    final c = widget.controller;
    _draft = {
      'statuses': Set<EventStatus>.from(c.statuses),
      'recruitmentTypes': Set<EventRecruitmentType>.from(c.recruitmentTypes),
    };
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final statusOptions = c.optionsStatuses;
    final typeOptions = c.optionsRecruitmentTypes;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bo loc',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const Text('Status', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: statusOptions.map((s) {
                final selected =
                    (_draft['statuses'] as Set<EventStatus>).contains(s);
                return FilterChip(
                  selected: selected,
                  label: Text(s.name.toUpperCase()),
                  onSelected: (_) {
                    setState(() {
                      if (selected) {
                        (_draft['statuses'] as Set<EventStatus>).remove(s);
                      } else {
                        (_draft['statuses'] as Set<EventStatus>).add(s);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Recruitment Type',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: typeOptions.map((s) {
                final selected =
                    (_draft['recruitmentTypes'] as Set<EventRecruitmentType>)
                        .contains(s);
                return FilterChip(
                  selected: selected,
                  label: Text(s.name),
                  onSelected: (_) {
                    setState(() {
                      if (selected) {
                        (_draft['recruitmentTypes']
                                as Set<EventRecruitmentType>)
                            .remove(s);
                      } else {
                        (_draft['recruitmentTypes']
                                as Set<EventRecruitmentType>)
                            .add(s);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _draft['statuses'] = <EventStatus>{};
                        _draft['recruitmentTypes'] = <EventRecruitmentType>{};
                      });
                    },
                    child: const Text('Xoa loc'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(_draft),
                    child: const Text('Ap dung'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
