import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/club_partition.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/usercases/session_user_cases.dart';
import '../../../infrastructure/api/providers/session_provider.dart';
import '../../../infrastructure/api/repositories/session_repository_impl.dart';
import '../../core/dates_carrousel/dates_carrousel.dart';
import '../session_manager_screen/widgets/reservate_session.dart';
import 'session_manager_event.dart';
import 'session_manager_state.dart';


class SessionManagerBloc extends Bloc<SessionManagerEvent, SessionManagerState> {

  final SessionUserCases _sessionUserCases = SessionUserCases(SessionRepositoryImplementation(sessionProvider: SessionProvider()));

  final DatesCarrouselController datesCarrouselController = DatesCarrouselController();

  SessionManagerBloc(int? sessionId) : super(SessionManagerState(currentDate: DateTime.now(), sessions: [], clubPartitions: [], isFirstLoad: true,)) {


    on<SessionChangeDateEvent>((event, emit) async {
      emit(
        state.copyWith(currentDate: event.newDate, isLoadingSessions: true),
      );
      
      datesCarrouselController.setDate!(event.newDate);

      final sessions = await _sessionUserCases.getSessions(state.currentDate); 
      
      emit(
        state.copyWith(
          sessions: sessions,
          isLoadingSessions: false,
        )
      );

    });

    on<SessionLoadEvent>((event, emit) async {
      emit(
        state.copyWith(isFirstLoad: true)
      );

      final [sessions as List<Session>, clubPartitions as List<ClubPartition>] = await Future.wait([
        _sessionUserCases.getSessions(state.currentDate),
        _sessionUserCases.getClubPartitions()
      ]);
      
      emit(
        state.copyWith(
          sessions: sessions,
          isFirstLoad: false,
          clubPartitions: clubPartitions,
          selectedClubPartition: clubPartitions.first
        )
      );
    });

    on<ChangeClubPartitionEvent>((event, emit){

      emit(
        state.copyWith(
          selectedClubPartition: event.newClubPartition
        )
      );

    });

    on<ReloadSessionsEvent>((event, emit) async {

      emit(
        state.copyWith(
          isLoadingSessions: true,
        )
      );

      final sessions = await _sessionUserCases.getSessions(state.currentDate); 

      emit(
        state.copyWith(
          sessions: sessions,
          isLoadingSessions: false
        )
      );

    },);

    
    on<SaveSessionEvent>((event, emit) async {

      final session = await _sessionUserCases.saveSession(event.session);

      emit(
        state.copyWith(
          sessions: [...state.sessions, session].sorted((a, b) => a.startTime.isAfter(b.startTime) ? 1 : 0,)
        )
      );
      
    });

    on<ReserveEvent>((event, emit) async {
      final reservatedClient = await _sessionUserCases.reservateSession(event.session, event.client);

      if(reservatedClient == null) return;

      final newSessions = state.sessions.map((element) {
        if(element.sessionId == event.session.sessionId){
          element = element.copyWith(client: reservatedClient, clientId: int.parse(reservatedClient.clientId!));
        }

        return element;
      }).toList();

      emit(
        state.copyWith(
          sessions: newSessions,
        )
      );
    });

    on<LoadFromSessionIdEvent>((event, emit) async {

      if(event.isFirstLoad){
        emit(
          state.copyWith(isFirstLoad: true)
        );
      }
      

      final [sessions as List<Session>, clubPartitions as List<ClubPartition>] = await Future.wait([
        _sessionUserCases.getSessionsBySessionId(event.sessionId),
        _sessionUserCases.getClubPartitions()
      ]);

      final session = sessions.firstWhere((element) => element.sessionId == event.sessionId);

      final selectedClubPartition = getNewSelectedClubPartition(session, clubPartitions);
      
      emit(
        state.copyWith(
          sessions: sessions,
          isFirstLoad: false,
          clubPartitions: clubPartitions,
          selectedClubPartition: selectedClubPartition,
          currentDate: session.startTime
        )
      );
    });
    
    if(sessionId == null) add(SessionLoadEvent());

    if(sessionId != null) add(LoadFromSessionIdEvent(sessionId, true));


  }



  ClubPartition getNewSelectedClubPartition(Session session, List<ClubPartition> clubPartitions){
    return clubPartitions.firstWhere((element) {
        final index = element.physicalPartitions!.indexWhere(
          (element) => element.partitionPhysicalId == session.partitionPhysicalId,
        );
      return index != -1;
    });
  }

  
}
