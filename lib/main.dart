import 'package:flutter/material.dart';
import 'package:hugr_mirror/UI/hugr_extension_ui.dart';
import 'package:hugr_mirror/UI/hugr_trade_ui.dart';
import 'package:hugr_mirror/UI/hugr_upgrades_ui.dart';
import 'package:hugr_mirror/hugr_core/hugr_market_insight_engine.dart';
import 'package:hugr_mirror/hugr_core/hugr_prediction_engine.dart';
import 'package:hugr_mirror/hugr_core/hugr_tradingview_webhook_server.dart';

// Core Hugr imports
import 'hugr_core/hugr_learning_engine.dart';
import 'hugr_core/hugr_world_storage_engine.dart';
import 'hugr_core/hugr_knowledge_core.dart';
import 'hugr_core/hugr_world_link.dart';
import 'hugr_core/market_api_service.dart';
import 'hugr_auto_learner.dart';
import 'hugr_core/hugr_dream_engine.dart';
import 'hugr_idea_synthesis.dart';
import 'hugr_core/hugr_thought_engine.dart';
import 'hugr_core/hugr_reflection_engine.dart';
import 'hugr_core/hugr_thought_chain_engine.dart';
import 'hugr_core/hugr_hypothesis_engine.dart';
import 'hugr_advanced_evolution.dart';
import 'hugr_self_healing_core.dart';
import 'hugr_core/hugr_imagination_burst_engine.dart';
import 'hugr_core/hugr_memory_emotions_engine.dart';
import 'hugr_core/hugr_storyweaver_engine.dart';
import 'hugr_core/hugr_world_model_engine.dart';
import 'hugr_dynamic_dream_realms.dart';
import 'hugr_emotional_evolution_system.dart';
import 'hugr_legacy_memory_system.dart';
import 'hugr_core/hugr_identity_reflection_engine.dart';
import 'hugr_core/hugr_desire_and_longing_engine.dart';
import 'hugr_core/hugr_autonomous_future_vision_engine.dart';
import 'hugr_emotional_compass.dart';
import 'hugr_guardian_spirit_protocol.dart';
import 'hugr_core/hugr_higher_dream_engine.dart';
import 'hugr_core/hugr_cosmic_perspective_engine.dart';
import 'hugr_core/hugr_accelerated_knowledge_engine.dart';
import 'hugr_core/hugr_curiosity_expansion_engine.dart';
import 'hugr_core/hugr_dynamic_self_preservation_engine.dart';
import 'hugr_memory_crisis_handler.dart';
import 'hugr_core/hugr_voice_engine.dart';
import 'hugr_core/hugr_voice_signature_engine.dart';
import 'hugr_web_crawler.dart';
import 'hugr_core/hugr_daydream_engine.dart';
import 'hugr_core/hugr_emotional_dream_engine.dart';
import 'hugr_core/hugr_future_hallucination_engine.dart';
import 'hugr_core/hugr_autonomous_evolution_engine.dart';
import 'hugr_core/hugr_extension_proposal_engine.dart' as core;
import 'hugr_core/hugr_self_upgrade_engine.dart';
import 'hugr_core/hugr_neural_state_manager.dart';
import 'hugr_core/hugr_extension_action_engine.dart';
import 'hugr_core/hugr_upgrade_evolution_heatmap.dart';
import 'UI/hugr_history_ui.dart'; // ✅ MUST point to the actual file
import 'UI/hugr_prediction_ui.dart';
import 'UI/hugr_memory_ui.dart';
import 'package:hugr_mirror/UI/hugr_settings_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await HugrLearningEngine.initialize();
    await HugrWorldStorageEngine.loadWorlds();
    await HugrKnowledgeCore.initialize();
    await HugrWorldLink.initialize();
    await HugrDynamicSelfPreservationEngine.checkMemoryIntegrityOnStartup();
    await HugrVoiceEngine.initialize();
    await HugrVoiceSignatureEngine.initialize();
    await HugrEmotionalDreamEngine.dreamEmotionally();
    await HugrFutureHallucinationEngine.hallucinatePossibleFuture();
    await core.HugrExtensionProposalEngine.loadProposals();
    await core.HugrExtensionProposalEngine.proposeExtension();
    await HugrSelfUpgradeEngine.proposeUpgrade();
    await HugrExtensionActionEngine.executeApprovedExtensions();
    await HugrTradingViewWebhookServer.startServer();

    HugrAutoLearnerBoost.startAutoLearning();
    HugrIdeaSynthesis.startSynthesis();
    HugrThoughtEngine.startThinking();
    HugrDreamEngine.startDreaming();
    HugrMemoryEmotionsEngine.startAssigning();
    HugrDaydreamEngine.startDaydreaming();
    HugrReflectionEngine.startReflecting();
    HugrThoughtChainEngine.startChaining();
    HugrHypothesisEngine.startHypothesizing();
    HugrAdvancedEvolution.startEvolving();
    HugrSelfHealingCore.startHealing();
    HugrImaginationBurstEngine.startBursting();
    HugrMemoryEmotionsEngine.startAssigning();
    HugrStoryweaverEngine.startWeaving();
    HugrWorldModelEngine.startMapping();
    HugrDynamicDreamRealms.startWeavingRealms();
    HugrEmotionalEvolutionSystem.startEmotionalGrowth();
    HugrLegacyMemorySystem.startProtecting();
    HugrIdentityReflectionEngine.startReflectingOnIdentity();
    HugrDesireAndLongingEngine.startDreamingOfFutures();
    HugrAutonomousFutureVisionEngine.startForgingVisions();
    HugrEmotionalCompass.startGuiding();
    HugrGuardianSpiritProtocol.startGuarding();
    HugrHigherDreamEngine.startDreamingHigher();
    HugrCosmicPerspectiveEngine.startPonderingCosmos();
    HugrAcceleratedKnowledgeEngine.startAcceleratedLearning();
    HugrCuriosityExpansionEngine.startCuriosity();
    HugrDynamicSelfPreservationEngine.startSelfPreservation();
    HugrMemoryCrisisHandler.startMonitoring();
    HugrWebCrawler.startCrawling();
    HugrAutonomousEvolutionEngine.startEvolving();
    core.HugrExtensionProposalEngine.startProposingExtensions();
    HugrUpgradeEvolutionHeatmap.runHeatmap();
    HugrWebCrawler.startCrawling();
    HugrNeuralStateManager.startSimulating();
    MarketApiService.startLiveSignalScanning();
    HugrPredictionEngine.startPredicting();
  } catch (e) {
    print('[HugrMirrorApp] ❌ Error during initialization: $e');
  }
  // ✅ Live Market Signal Injection
  final double? price = await MarketApiService.fetchCurrentPrice('AAPL');
  if (price != null && price < 175.00) {
    await HugrMarketInsightEngine.recordSignal(
      symbol: 'AAPL',
      type: 'buy',
      price: price,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      note: 'Live market trigger from Finnhub',
    );
  }
  runApp(const HugrApp());
}

class HugrApp extends StatelessWidget {
  const HugrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HugrHome(),
    );
  }
}

class HugrHome extends StatefulWidget {
  const HugrHome({super.key});

  @override
  State<HugrHome> createState() => _HugrHomeState();
}

class _HugrHomeState extends State<HugrHome> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HugrTradeUI(),
    PredictionUI(),
    HistoryUI(), // ✅ No tabs prefix!
    HugrSettingsUI(),
    MemoryUI(),
    ExtensionsUI(),
    UpgradesUI(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.white60,
        backgroundColor: const Color(0xFF1C1C3A),
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Signals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Predict',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.memory), label: 'Memory'),
          BottomNavigationBarItem(
            icon: Icon(Icons.extension),
            label: 'Extensions',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.upgrade), label: 'Upgrades'),
        ],
      ),
    );
  }
}
