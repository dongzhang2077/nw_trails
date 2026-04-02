import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nw_trails/core/models/landmark.dart';
import 'package:nw_trails/core/models/route_plan.dart';

/// Location simulation panel used for manual testing.
class TestModePanel extends StatefulWidget {
  const TestModePanel({
    super.key,
    required this.landmarks,
    required this.activeRoute,
    required this.currentPosition,
    required this.joystickSpeed,
    required this.usingInjectedLocation,
    required this.onTeleport,
    required this.onUseDeviceLocation,
    required this.onJoystickSpeedChanged,
    required this.onClose,
    this.completedLandmarkIds = const <String>{},
    this.nextRouteStopId,
  });

  final List<Landmark> landmarks;
  final RoutePlan? activeRoute;
  final Map<String, double>? currentPosition;
  final double joystickSpeed;
  final bool usingInjectedLocation;
  final void Function(double lat, double lng) onTeleport;
  final Future<Map<String, double>?> Function() onUseDeviceLocation;
  final void Function(double speed) onJoystickSpeedChanged;
  final VoidCallback onClose;
  final Set<String> completedLandmarkIds;
  final String? nextRouteStopId;

  @override
  State<TestModePanel> createState() => _TestModePanelState();
}

class _TestModePanelState extends State<TestModePanel> {
  int _selectedDistanceMeters = 10;
  double? _currentLat;
  double? _currentLng;
  late bool _usingInjectedLocation;

  @override
  void initState() {
    super.initState();
    _currentLat = widget.currentPosition?['lat'];
    _currentLng = widget.currentPosition?['lng'];
    _usingInjectedLocation = widget.usingInjectedLocation;
  }

  void _teleport(double lat, double lng, {String? message}) {
    setState(() {
      _currentLat = lat;
      _currentLng = lng;
      _usingInjectedLocation = true;
    });
    widget.onTeleport(lat, lng);
    if (message != null) {
      _showSnackBar(message);
    }
  }

  Future<void> _switchToRealDeviceLocation() async {
    try {
      final Map<String, double>? coordinates =
          await widget.onUseDeviceLocation();
      setState(() {
        _usingInjectedLocation = false;
        if (coordinates != null) {
          _currentLat = coordinates['lat'];
          _currentLng = coordinates['lng'];
        }
      });
      _showSnackBar('Switched to real device location.');
    } catch (_) {
      _showSnackBar('Could not switch to real device location.');
    }
  }

  void _teleportToLandmark(Landmark landmark) {
    final coords = landmark.point.coordinates;
    _teleport(
      coords.lat.toDouble(),
      coords.lng.toDouble(),
      message: 'Teleported to: ${landmark.name}',
    );
  }

  void _teleportToRouteStop(String landmarkId) {
    final Landmark? landmark = widget.landmarks
        .where((Landmark item) => item.id == landmarkId)
        .firstOrNull;
    if (landmark != null) {
      _teleportToLandmark(landmark);
    }
  }

  void _nudgeByMeters({required double north, required double east}) {
    final double? lat = _currentLat;
    final double? lng = _currentLng;
    if (lat == null || lng == null) {
      _showSnackBar('Select a landmark first.');
      return;
    }

    const double metersPerDegreeLat = 111000;
    final double latDelta = north / metersPerDegreeLat;
    final double metersPerDegreeLng =
        metersPerDegreeLat * math.cos(lat * math.pi / 180).abs();
    final double lngDelta =
        metersPerDegreeLng < 0.000001 ? 0 : east / metersPerDegreeLng;

    _teleport(lat + latDelta, lng + lngDelta, message: 'Position nudged.');
  }

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _shortName(String text, {int max = 10}) {
    if (text.length <= max) {
      return text;
    }
    return '${text.substring(0, max)}...';
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final BorderSide buttonBorder = BorderSide(color: colors.outlineVariant);
    const TextStyle buttonText = TextStyle(
      color: Colors.black,
      fontSize: 11,
      fontWeight: FontWeight.w600,
    );

    return SafeArea(
      top: false,
      child: Material(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 8, 8),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '🧪 Test Mode',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: widget.onClose,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: buttonBorder,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Close'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _usingInjectedLocation
                          ? 'Location mode: Simulated'
                          : 'Location mode: Real device',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _switchToRealDeviceLocation,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: buttonBorder,
                    ),
                    icon: const Icon(Icons.my_location, size: 16),
                    label: const Text('Use Real GPS'),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.65,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildSectionTitle(context, '📍 Quick Teleport'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.landmarks.map((Landmark landmark) {
                        final bool completed =
                            widget.completedLandmarkIds.contains(landmark.id);
                        return ActionChip(
                          avatar: completed
                              ? const Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: Colors.black,
                                )
                              : null,
                          label: Text(
                            _shortName(landmark.name),
                            style: buttonText,
                          ),
                          backgroundColor: Colors.white,
                          side: buttonBorder,
                          onPressed: () => _teleportToLandmark(landmark),
                        );
                      }).toList(growable: false),
                    ),
                    if (widget.activeRoute != null) ...<Widget>[
                      const SizedBox(height: 20),
                      _buildSectionTitle(
                        context,
                        '🎯 Route: ${widget.activeRoute!.name}',
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          for (
                            int i = 0;
                            i < widget.activeRoute!.landmarkIds.length;
                            i++
                          )
                            Builder(
                              builder: (BuildContext _) {
                                final String landmarkId =
                                    widget.activeRoute!.landmarkIds[i];
                                final Landmark? landmark = widget.landmarks
                                    .where(
                                      (Landmark item) => item.id == landmarkId,
                                    )
                                    .firstOrNull;
                                final bool isNext =
                                    landmarkId == widget.nextRouteStopId;
                                final bool completed = widget.completedLandmarkIds
                                    .contains(landmarkId);
                                final String name =
                                    landmark == null ? landmarkId : landmark.name;
                                final String prefix = completed
                                    ? 'Done'
                                    : isNext
                                        ? 'Next'
                                        : 'Stop';

                                return ActionChip(
                                  avatar: Icon(
                                    completed
                                        ? Icons.check_circle
                                        : isNext
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_unchecked,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                  label: Text(
                                    '$prefix ${i + 1}: ${_shortName(name, max: 8)}',
                                    style: buttonText,
                                  ),
                                  backgroundColor: Colors.white,
                                  side: buttonBorder,
                                  onPressed: () => _teleportToRouteStop(landmarkId),
                                );
                              },
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 20),
                    _buildSectionTitle(context, '🔧 Position Nudge'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: <Widget>[
                        ChoiceChip(
                          label: const Text('±10m'),
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          selected: _selectedDistanceMeters == 10,
                          backgroundColor: Colors.white,
                          selectedColor: Colors.white,
                          side: buttonBorder,
                          onSelected: (_) {
                            setState(() {
                              _selectedDistanceMeters = 10;
                            });
                          },
                        ),
                        ChoiceChip(
                          label: const Text('±50m'),
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          selected: _selectedDistanceMeters == 50,
                          backgroundColor: Colors.white,
                          selectedColor: Colors.white,
                          side: buttonBorder,
                          onSelected: (_) {
                            setState(() {
                              _selectedDistanceMeters = 50;
                            });
                          },
                        ),
                        ChoiceChip(
                          label: const Text('±100m'),
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          selected: _selectedDistanceMeters == 100,
                          backgroundColor: Colors.white,
                          selectedColor: Colors.white,
                          side: buttonBorder,
                          onSelected: (_) {
                            setState(() {
                              _selectedDistanceMeters = 100;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Column(
                        children: <Widget>[
                          _buildDirectionButton(
                            context,
                            icon: Icons.arrow_upward,
                            tooltip: 'North',
                            onPressed: () => _nudgeByMeters(
                              north: _selectedDistanceMeters.toDouble(),
                              east: 0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _buildDirectionButton(
                                context,
                                icon: Icons.arrow_back,
                                tooltip: 'West',
                                onPressed: () => _nudgeByMeters(
                                  north: 0,
                                  east: -_selectedDistanceMeters.toDouble(),
                                ),
                              ),
                              const SizedBox(width: 60),
                              _buildDirectionButton(
                                context,
                                icon: Icons.arrow_forward,
                                tooltip: 'East',
                                onPressed: () => _nudgeByMeters(
                                  north: 0,
                                  east: _selectedDistanceMeters.toDouble(),
                                ),
                              ),
                            ],
                          ),
                          _buildDirectionButton(
                            context,
                            icon: Icons.arrow_downward,
                            tooltip: 'South',
                            onPressed: () => _nudgeByMeters(
                              north: -_selectedDistanceMeters.toDouble(),
                              east: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle(context, '⚡ Joystick Speed'),
                    Row(
                      children: <Widget>[
                        const Text('Slow', style: TextStyle(fontSize: 12)),
                        Expanded(
                          child: Slider(
                            value: widget.joystickSpeed,
                            min: 1,
                            max: 50,
                            divisions: 49,
                            label: '${widget.joystickSpeed.toInt()}x',
                            onChanged: widget.onJoystickSpeedChanged,
                          ),
                        ),
                        const Text('Fast', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${widget.joystickSpeed.toInt()}x',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colors.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (_currentLat != null && _currentLng != null) ...<Widget>[
                      _buildSectionTitle(context, '📌 Current Position'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: colors.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Lat: ${_currentLat!.toStringAsFixed(6)}\n'
                                'Lng: ${_currentLng!.toStringAsFixed(6)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }

  Widget _buildDirectionButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          side: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          elevation: 0,
          minimumSize: const Size(50, 50),
          padding: EdgeInsets.zero,
        ),
        child: Icon(icon),
      ),
    );
  }
}
