import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/assoiciation_link_cubit/association_link_cubit.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/app_info/faq_item_model.dart';
import 'package:kalivra/view/widgets/empty_state_view.dart';
import 'package:kalivra/view/widgets/faq/faq_list.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AssociationFaqScreen extends StatelessWidget {
  const AssociationFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => AssociationLinkCubit()..fetchFaqs(),
      child: Scaffold(
        appBar: ScreenAppBar(title: l10n.frequentlyAskedQuestion),
        body: BlocBuilder<AssociationLinkCubit, AssociationLinkState>(
          builder: (context, state) {
            switch (state) {
              case AssociationFaqsFetched():
                if (state.faqs.isEmpty) {
                  return EmptyStateView(
                    icon: Icons.help_outline_rounded,
                    title: l10n.associationMemberNoData,
                    description: l10n.frequentlyAskedQuestion,
                  );
                }
                return FaqList(faqs: state.faqs);
              case AssociationLinkFailure():
                return EmptyStateView(
                  icon: Icons.error_outline_rounded,
                  title: l10n.unexpectedError,
                  description: state.errorMessage,
                );
              case AssociationLinkLoading():
                return Skeletonizer(
                  child: FaqList(
                    faqs: [
                      FaqItemModel(
                        id: 1,
                        category: 'category',
                        question: 'question',
                        answer: 'answer',
                        sortOrder: 1,
                      ),
                      FaqItemModel(
                        id: 1,
                        category: 'category',
                        question: 'question',
                        answer: 'answer',
                        sortOrder: 1,
                      ),
                      FaqItemModel(
                        id: 1,
                        category: 'category',
                        question: 'question',
                        answer: 'answer',
                        sortOrder: 1,
                      ),
                    ],
                  ),
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
