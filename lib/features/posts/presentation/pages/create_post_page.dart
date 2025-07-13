import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod_tmplt/core/presentation/widgets/common/loading_widget.dart';
import 'package:flutter_riverpod_tmplt/features/posts/presentation/controllers/create_post_state.dart';
import 'package:flutter_riverpod_tmplt/features/posts/presentation/controllers/create_post_controller.dart';
import 'package:flutter_riverpod_tmplt/core/presentation/widgets/adaptive/adaptive_scaffold.dart';
import 'package:flutter_riverpod_tmplt/core/presentation/widgets/adaptive/adaptive_button.dart';
import 'package:flutter_riverpod_tmplt/core/presentation/theme/adaptive_theme.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _userIdController = TextEditingController(text: '1'); // Default user ID

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    
    await ref.read(createPostControllerProvider.notifier).createPost(
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      userId: int.parse(_userIdController.text.trim()),
    );
  }

  void _showMessage(String message, {required bool isSuccess}) {
    final l10n = AppLocalizations.of(context)!;
    if (AdaptiveTheme.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(isSuccess ? l10n.success : l10n.error),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: Text(l10n.ok),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isSuccess ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final createPostState = ref.watch(createPostControllerProvider);
    
    // مراقبة التغييرات في الحالة
    ref.listen<CreatePostState>(createPostControllerProvider, (previous, next) {
      if (next.isSuccess && next.createdPost != null) {
        _showMessage('${l10n.postCreated} ID: ${next.createdPost!.id}', isSuccess: true);
        Navigator.pop(context, true);
        // إعادة تعيين الحالة
        ref.read(createPostControllerProvider.notifier).clearSuccess();
      } else if (next.error != null) {
        _showMessage('${l10n.postCreationFailed}: ${next.error}', isSuccess: false);
        ref.read(createPostControllerProvider.notifier).clearError();
      }
    });
    
    return AdaptiveScaffold(
      title: l10n.createNewPost,
      body: createPostState.isLoading
          ? LoadingWidget(message: l10n.creatingPost)
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      controller: _titleController,
                      label: l10n.postTitle,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.requiredField;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _bodyController,
                      label: l10n.postBody,
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.requiredField;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _userIdController,
                      label: l10n.postAuthor,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.requiredField;
                        }
                        if (int.tryParse(value.trim()) == null) {
                          return l10n.invalidInput;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    AdaptiveButton(
                      text: l10n.createPost,
                      onPressed: _createPost,
                      isLoading: createPostState.isLoading,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    if (AdaptiveTheme.isIOS) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: CupertinoTextField(
          controller: controller,
          placeholder: label,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: BoxDecoration(
            border: Border.all(color: CupertinoColors.separator),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } else {
      return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
      );
    }
  }
} 