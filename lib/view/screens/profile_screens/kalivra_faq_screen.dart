import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/app_info_cubit/app_info_cubit.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/empty_state_view.dart';
import 'package:kalivra/view/widgets/faq/faq_list.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

class KalivraFaqScreen extends StatelessWidget {
  const KalivraFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => AppInfoCubit()..getKalivraFaqs(),
      child: Scaffold(
        appBar: ScreenAppBar(title: l10n.frequentlyAskedQuestion),
        body: BlocBuilder<AppInfoCubit, AppInfoState>(
          builder: (context, state) {
            switch (state) {
              case AppFaqsFetched():
                if (state.faqs.isEmpty) {
                  return EmptyStateView(
                    icon: Icons.help_outline_rounded,
                    title: l10n.associationMemberNoData,
                    description: l10n.frequentlyAskedQuestion,
                  );
                }
                return FaqList(faqs: state.faqs);
              case AppInfoFailure():
                return EmptyStateView(
                  icon: Icons.error_outline_rounded,
                  title: l10n.unexpectedError,
                  description: state.errorMessage,
                );
              case AppInfoLoading():
                return const Center(child: CircularProgressIndicator());
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
