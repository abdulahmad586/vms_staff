import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/dashboard/dashboard.dart';
import 'package:shevarms_user/shared/shared.dart';

class Dashboard extends KFDrawerContent {

  @override
  State<Dashboard> createState() => _DashboardState();
}

class DashboardStat{
  String label;
  String category;
  String value2;
  dynamic value;
  IconData icon;

  DashboardStat({required this.category, required this.label, required this.value, this.value2="", this.icon = Icons.info});

}

class DashboardSection{
  String category;
  int pageLimit;
  List<DashboardStat> stats;

  DashboardSection(this.category, this.stats, {this.pageLimit = 4});

  static List<DashboardSection> fromStats(List<DashboardStat> stats){
    List<String> allCategories = [];
    for(var stat in stats){
      if(!allCategories.contains(stat.category)){
        allCategories.add(stat.category);
      }
    }
    return allCategories.map((e) => DashboardSection(e, stats.where((element) => element.category == e).toList())).toList();

  }

}

class _DashboardState extends State<Dashboard> {

  int selectedTab =0;
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  // List<DashboardSection> dashboardSections = [
  //   DashboardSection('Meetings', [
  //     DashboardStat(category: 'Meetings', label: 'Today', value: 'No meetings'),
  //     DashboardStat(category: 'Meetings', label: 'This week', value: '4 meetings'),
  //   ]),
  // ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: Icon(Icons.menu), onPressed: (){
        widget.onMenuPressed!();
      } ), title: Text('DASHBOARD', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primaryColor, fontFamily: 'Iceberg')),),

      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(10),

            child: Column(
              children: [
                BlocBuilder<AppCubit,AppState>(builder: (context,state){
                  return UserCard(
                    user:
                    state.user!,
                  );
                }),
                const SizedBox(height: 20),
                   BlocProvider<DashboardCubit>(create: (context)=>DashboardCubit(DashboardState(),refreshController: refreshController),
                    child: BlocBuilder<DashboardCubit, DashboardState>(builder: (context, state){
                      List<DashboardSection> dashboardSections = state.results??[];
                      if(dashboardSections.isEmpty){
                        return EmptyResult(message:'No stats available', loading:state.loading??false);
                      }

                      return Column(
                        children: List.generate(dashboardSections.length, (index) {
                          return DashboardSectionWidget(section: dashboardSections[index]);
                        }),
                      );
                    },),
                    ),

              ],

            )),
      ),
    );
  }
}

class DashboardSectionWidget extends StatelessWidget{
  final DashboardSection section;
  DashboardSectionWidget({required this.section, super.key});

  final ValueNotifier<bool> expanded = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    int length = section.stats.length;
    int heightOfSingle = 120;

    return ValueListenableBuilder(
      valueListenable: expanded,
      builder: (context, bool isExpanded, child) {
        int dispLength = isExpanded ? length : ( length >= section.pageLimit ? section.pageLimit : length);
        double height = dispLength % 2 == 0 ? (dispLength / 2) * heightOfSingle : ((dispLength + 1) / 2) * heightOfSingle;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(section.category ,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: 'Iceberg',
                        fontSize: 18,
                        color: AppColors.primaryColor)),
                CustomIconButton(isExpanded ? Icons.arrow_circle_up_outlined : Icons.arrow_circle_down_outlined, iconSize: 25, iconColor: Theme.of(context).primaryColor, onPressed: (){
                  expanded.value = !expanded.value;
                }),
              ],
            ),
            const SizedBox(height:10),
            SizedBox(
              height:height,
              child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.5,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                    dispLength,
                        (index2) => DashboardStatWidget(
                      backgroundColor: Colors.white,
                      height: 70,
                      icon: section.stats[index2].icon,
                      label: section.stats[index2].label,
                      display2: section.stats[index2].value2.toString(),
                      display: section.stats[index2].value.toString(),
                    ),
                  )),
            ),
            const SizedBox(height:10),
          ],
        );
      }
    );
  }
}
