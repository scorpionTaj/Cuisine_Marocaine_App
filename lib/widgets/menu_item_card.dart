import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/menu_item.dart';

class MenuItemCard extends StatefulWidget {
  final MenuItem menuItem;
  final VoidCallback? onUpdate;

  const MenuItemCard({
    Key? key,
    required this.menuItem,
    this.onUpdate,
  }) : super(key: key);

  @override
  _MenuItemCardState createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard>
    with SingleTickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  bool _showComments = false;
  final bool _isSubmittingComment = false;
  bool _likeAnimated = false;
  bool _dislikeAnimated = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleLike() async {
    setState(() {
      widget.menuItem.likes++;
      _likeAnimated = true;
    });
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _likeAnimated = false;
    });
    if (widget.onUpdate != null) widget.onUpdate!();
  }

  Future<void> _handleDislike() async {
    setState(() {
      widget.menuItem.dislikes++;
      _dislikeAnimated = true;
    });
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _dislikeAnimated = false;
    });
    if (widget.onUpdate != null) widget.onUpdate!();
  }

  Future<void> _handleToggleFavorite() async {
    setState(() {
      widget.menuItem.isFavorite = !widget.menuItem.isFavorite;
    });
    if (widget.onUpdate != null) widget.onUpdate!();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.menuItem.isFavorite
            ? 'Ajouté aux favoris'
            : 'Retiré des favoris'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _submitComment() async {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) return;
    setState(() {
      widget.menuItem.comments.add(comment);
      _commentController.clear();
    });
    if (widget.onUpdate != null) widget.onUpdate!();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Commentaire ajouté avec succès!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section avec FadeIn
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 700),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: child,
                ),
                child: Image.asset(
                  widget.menuItem.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Image non disponible',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Content Section
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Favorite Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.menuItem.name,
                        style: GoogleFonts.cairo(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _handleToggleFavorite,
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, anim) =>
                            ScaleTransition(scale: anim, child: child),
                        child: widget.menuItem.isFavorite
                            ? const Icon(Icons.favorite,
                                color: Colors.red, key: ValueKey('fav'))
                            : const Icon(Icons.favorite_border,
                                color: Colors.grey, key: ValueKey('notfav')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  widget.menuItem.description,
                  style:
                      GoogleFonts.cairo(fontSize: 16, color: Colors.grey[800]),
                ),
                const SizedBox(height: 12),
                // Price
                Text(
                  '${widget.menuItem.price.toStringAsFixed(2)} MAD',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Like/Dislike/Comments Row
                Row(
                  children: [
                    GestureDetector(
                      onTap: _handleLike,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              _likeAnimated ? Colors.green[100] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _likeAnimated
                              ? [
                                  BoxShadow(
                                      color: Colors.green.withOpacity(0.2),
                                      blurRadius: 8)
                                ]
                              : [],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.thumb_up,
                                color: Colors.green, size: 20),
                            const SizedBox(width: 4),
                            Text('${widget.menuItem.likes}',
                                style: GoogleFonts.cairo()),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _handleDislike,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              _dislikeAnimated ? Colors.red[100] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _dislikeAnimated
                              ? [
                                  BoxShadow(
                                      color: Colors.red.withOpacity(0.2),
                                      blurRadius: 8)
                                ]
                              : [],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.thumb_down,
                                color: Colors.red, size: 20),
                            const SizedBox(width: 4),
                            Text('${widget.menuItem.dislikes}',
                                style: GoogleFonts.cairo()),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _showComments = !_showComments;
                        });
                      },
                      icon: Icon(_showComments
                          ? Icons.expand_less
                          : Icons.expand_more),
                      label: Text(
                          'Commentaires (${widget.menuItem.comments.length})',
                          style: GoogleFonts.cairo()),
                    ),
                  ],
                ),
                // Comments Section
                if (_showComments) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  // Add Comment Section
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Ajouter un commentaire...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          maxLines: 2,
                          enabled: !_isSubmittingComment,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _isSubmittingComment ? null : _submitComment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isSubmittingComment
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(Icons.send),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Comments List
                  if (widget.menuItem.comments.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Aucun commentaire pour le moment.',
                        style: GoogleFonts.cairo(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.menuItem.comments.map((comment) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.person,
                                size: 20,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  comment,
                                  style: GoogleFonts.cairo(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
