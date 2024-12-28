// ignore_for_file: prefer_const_constructors

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/config/service_locator.dart';
import '../../../domain/entities/client.dart';
import '../../../domain/repositories/admin_repository.dart';
import '../../../infrastructure/api/providers/admin_provider.dart';
import '../../../infrastructure/api/repositories/admin_repository_impl.dart';
import 'bloc/clients_list_bloc.dart';
import 'list_utils/client_list_filters.dart';
import 'list_utils/clients_data_source.dart';
import 'list_utils/clients_data_source_sf.dart';
import 'widgets/client_list_filters_container.dart';
import 'widgets/client_list_header.dart';

class ClientsList extends StatefulWidget {
  const ClientsList({super.key});

  @override
  State<ClientsList> createState() => _ClientsListState();
}

class _ClientsListState extends State<ClientsList> {

  bool isLoading = false;
  final source = ClientsDataSourceSf(sl<AdminRepository>(), ClientListFilters());

  @override
  void initState() {
    super.initState();
    source.addListener(_onDataSourceChanged);
  }

  @override
  void dispose() {
    source.removeListener(_onDataSourceChanged);
    super.dispose();
  }

  void _onDataSourceChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final clientsBloc = BlocProvider.of<ClientsListBloc>(context);
    
    return Stack(
      children: [
        Column(
          children: [
            ClientListHeader(),
            ClientListFiltersContainer(),
            Expanded(
              child: AsyncPaginatedDataTable2(
                source: clientsBloc.state.dataSource,
            errorBuilder: (error) => Center(child: Text(error.toString())),
            wrapInCard: false,
            dragStartBehavior: DragStartBehavior.down,
            sortColumnIndex: 3,
            //source: clientsBloc.state.dataSource,
            empty: Center(child: Text("No se encontraron Clientes")),
            rowsPerPage: 15,
            columns:  [
              DataColumn2(
                fixedWidth: 70,
                label: const Row(
                  children: [
                    Text("ID"),
                  ],
                ),
              ),
              DataColumn2(
                label: Text("Cliente"),


              ),
              DataColumn2(
                label: Text("Telefono"),
              ),
              DataColumn2(
                label: Text("Email"),
              ),
              DataColumn2(
                fixedWidth: 150,
                label: Text("Estado"),
              ),
              DataColumn2(
                label: Text("Etiquetas"),
              ),
            ],
          )
            ),
          
          ],
        ),
        if(isLoading) Center(child: CircularProgressIndicator()),
      ],
    );
  }

  List<GridColumn> get buildColumns {
    return [
      GridColumn(
        width: 80,
        columnName: "id", 
        label: tinyColumnWrapper(Text("ID")),
      ),
      GridColumn(columnName: "name", label: columnWrapper(Text("Nombre"))), 
      GridColumn(columnName: "phone", label: columnWrapper(Text("Telefono"))),
      GridColumn(columnName: "email", label: columnWrapper(Text("Email"))),
      GridColumn(width: 110, columnName: "status", label: tinyColumnWrapper(Text("Estado"))),
      GridColumn(columnName: "labels", label: columnWrapper(Text("Etiquetas"))),
    ];
  }
}

columnWrapper(Text text) => Column(
  children: [
    Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Align(alignment: Alignment.centerLeft, child: text),
      ),
    ),
    Divider(height: 1),
  ],
);

tinyColumnWrapper(Text text) => Column(
  children: [
    Expanded(
      child: Center(child: text),
    ),
    Divider(height: 1),
  ],
);