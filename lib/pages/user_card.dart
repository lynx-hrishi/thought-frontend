import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import '../theme.dart';
import '../widgets/dio_image.dart';

class UserCard extends StatefulWidget {
  final UserModel user;
  final VoidCallback onLike;
  final VoidCallback onReject;

  const UserCard({
    super.key,
    required this.user,
    required this.onLike,
    required this.onReject,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> with SingleTickerProviderStateMixin {
  int currentImageIndex = 0;
  late AnimationController _swipeController;
  late Animation<Offset> _swipeAnimation;
  Offset _dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _swipeAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
      CurvedAnimation(parent: _swipeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  void _animateSwipe(bool isLike) {
    _swipeController.reset();
    final endOffset = isLike ? const Offset(2, 0) : const Offset(-2, 0);
    setState(() {
      _swipeAnimation = Tween<Offset>(begin: Offset.zero, end: endOffset).animate(
        CurvedAnimation(parent: _swipeController, curve: Curves.easeInOut),
      );
    });

    _swipeController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (isLike) {
          widget.onLike();
        } else {
          widget.onReject();
        }
      });
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    const threshold = 100.0;
    if (details.velocity.pixelsPerSecond.dx > threshold) {
      _animateSwipe(true);
    } else if (details.velocity.pixelsPerSecond.dx < -threshold) {
      _animateSwipe(false);
    } else {
      setState(() => _dragOffset = Offset.zero);
    }
  }

  String _getZodiacEmoji(String zodiacSign) {
    switch (zodiacSign) {
      case 'ARIES': return '♈';
      case 'TAURUS': return '♉';
      case 'GEMINI': return '♊';
      case 'CANCER': return '♋';
      case 'LEO': return '♌';
      case 'VIRGO': return '♍';
      case 'LIBRA': return '♎';
      case 'SCORPIO': return '♏';
      case 'SAGITTARIUS': return '♐';
      case 'CAPRICON': return '♑';
      case 'AQUARIS': return '♒';
      case 'PISCES': return '♓';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _swipeAnimation,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            _dragOffset = Offset(details.delta.dx / 100, 0);
          });
        },
        onHorizontalDragEnd: _handleDragEnd,
        child: Transform.translate(
          offset: _dragOffset * 100,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              child: Column(
                children: [
                  // Image Carousel
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: Image(
                            image: DioImage(widget.user.images[currentImageIndex]),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              );
                            },
                          ),
                        ),
                        // Image indicators
                        Positioned(
                          top: 12,
                          left: 12,
                          right: 12,
                          child: Row(
                            children: List.generate(
                              widget.user.images.length,
                              (index) => Expanded(
                                child: Container(
                                  height: 3,
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: index == currentImageIndex
                                        ? Colors.white
                                        : Colors.white54,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Previous image button
                        Positioned(
                          left: 12,
                          top: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                currentImageIndex = (currentImageIndex - 1 +
                                        widget.user.images.length) %
                                    widget.user.images.length;
                              });
                            },
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                        // Next image button
                        Positioned(
                          right: 12,
                          top: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                currentImageIndex =
                                    (currentImageIndex + 1) %
                                        widget.user.images.length;
                              });
                            },
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // User Info
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.user.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8, height: 4,),
                                Text(
                                  '${_getZodiacEmoji(widget.user.zodiacSign)} ${widget.user.zodiacSign}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.user.profession,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: widget.user.interests
                                  .take(3)
                                  .map(
                                    (interest) => Chip(
                                      label: Text(
                                        interest,
                                        style: GoogleFonts.poppins(fontSize: 12),
                                      ),
                                      backgroundColor: AppTheme.pink.withOpacity(0.2),
                                      labelStyle: const TextStyle(
                                        color: AppTheme.pink,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 10),
                            if (widget.user.partnerPreference != null)
                              Text(
                                widget.user.partnerPreference!,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton(
                          onPressed: () => _animateSwipe(false),
                          backgroundColor: Colors.grey[300],
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () => _animateSwipe(true),
                          backgroundColor: AppTheme.pink,
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
