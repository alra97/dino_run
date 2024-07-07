import 'dart:math';
import 'package:flame/components.dart';
import '/game/enemy.dart';
import '/game/dino_run.dart';
import '/models/enemy_data.dart';
import '/models/player_data.dart';

// This class is responsible for spawning random enemies at certain
// intervals of time depending upon the player's current score.
class EnemyManager extends Component with HasGameReference<DinoRun> {
  // A list to hold data for all the enemies.
  final List<EnemyData> _data = [];

  // Random generator required for randomly selecting enemy type.
  final Random _random = Random();

  // Timer to decide when to spawn the next enemy.
  final Timer _timer = Timer(2, repeat: true);

  // Variable to track the last spawned enemy
  String? _lastSpawnedEnemyKey;

  EnemyManager() {
    _timer.onTick = spawnRandomEnemy;
  }

  // This method is responsible for spawning a random enemy.
  void spawnRandomEnemy() {
    // Get player data from the game reference
    final playerData = game.playerData;

    // Filter the enemies based on the player's lives
    List<EnemyData> availableEnemies = _data.toList();

    // Randomly select pinkBat with a frequency of 1 in 20
    final bool selectPinkBat = _random.nextInt(20) == 0;

    if (selectPinkBat) {
      availableEnemies =
          _data.where((enemyData) => enemyData.key == 'pinkBat').toList();
    } else {
      availableEnemies =
          _data.where((enemyData) => enemyData.key != 'pinkBat').toList();
    }

    // Ensure there are available enemies to spawn
    if (availableEnemies.isEmpty) return;

    // Select a random enemy from the available enemies
    final boopEnemyIndex = availableEnemies
        .indexWhere((enemyData) => enemyData.image.toString().contains('boop'));

    EnemyData enemyData;
    if (boopEnemyIndex != -1) {
      // "boop" enemy found, prioritize spawning it
      enemyData = availableEnemies[boopEnemyIndex];
    } else {
      // "boop" enemy not found, proceed with normal random selection
      final randomIndex = _random.nextInt(availableEnemies.length);
      enemyData = availableEnemies[randomIndex];
    }

    final enemy = Enemy(enemyData);

    // Help in setting all enemies on ground.
    enemy.anchor = Anchor.bottomLeft;
    enemy.position = Vector2(
      game.virtualSize.x + 32,
      game.virtualSize.y - 24,
    );

    // If this enemy can fly, set its y position randomly.
    if (enemyData.canFly) {
      final newHeight = _random.nextDouble() * 2 * enemyData.textureSize.y;
      enemy.position.y -= newHeight;
    }

    // Due to the size of our viewport, we can
    // use textureSize as size for the components.
    enemy.size = enemyData.textureSize;
    game.world.add(enemy);
  }

  @override
  void onMount() {
    if (isMounted) {
      removeFromParent();
    }

    // Don't fill list again and again on every mount.
    if (_data.isEmpty) {
      // As soon as this component is mounted, initialize all the data.
      _data.addAll([
        EnemyData(
          image: game.images.fromCache('AngryPig/Walk (36x30).png'),
          nFrames: 16,
          stepTime: 0.1,
          textureSize: Vector2(36, 30),
          speedX: 80,
          canFly: false,
          key: 'pigwalk',
        ),
        EnemyData(
          image: game.images.fromCache('Bat/Flying (46x30).png'),
          nFrames: 7,
          stepTime: 0.1,
          textureSize: Vector2(46, 30),
          speedX: 100,
          canFly: true,
          key: 'blackBat',
        ),
        EnemyData(
          image: game.images.fromCache('Rino/Run (52x34).png'),
          nFrames: 6,
          stepTime: 0.09,
          textureSize: Vector2(52, 34),
          speedX: 150,
          canFly: false,
          key: 'rinowalk',
        ),
        EnemyData(
          image: game.images.fromCache('boop/run.jpg'),
          nFrames:
              7, // Replace with the actual number of animation frames in "boop.jpg"
          stepTime: 0.09, // Adjust if needed for animation speed
          textureSize: Vector2(52, 34),
          speedX: 150,
          canFly: false,
          key: 'boopwalk',
        ),
        EnemyData(
          image: game.images.fromCache('pink/fly.png'),
          nFrames:
              7, // Replace with the actual number of animation frames in "pinkBat.png"
          stepTime: 0.1, // Adjust if needed for animation speed
          textureSize: Vector2(46, 30),
          speedX: 100,
          canFly: true,
          key: 'pinkBat',
        ),
      ]);
    }
    _timer.start();
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    super.update(dt);
  }

  void removeAllEnemies() {
    final enemies = game.world.children.whereType<Enemy>();
    for (var enemy in enemies) {
      enemy.removeFromParent();
    }
  }
}
