<template>
    <div class="container" id="app">
        <h1 class="title">Simon Says</h1>
        <div class="circle-group">
            <div class="circle">
                <button
                    :class="[color, { active: index === activeColor }]"
                    v-for="(color, index) in colors"
                    :disabled="gameActive || currentGame.length == 0"
                    @click="!gameActive && currentGame.length > 0 ? setColor(index) : ''"
                    :key="index"
                ></button>
            </div>
            <div class="round-info">
                <h2>Раунд: {{ round }}</h2>
                <button
                    class="btn-start"
                    @click="
                        currentGame = [];
                        playerResult = [];
                        round = 0;
                        startGame();
                    "
                    :disabled="gameActive"
                >
                    Старт
                </button>
            </div>
            <div class="options">
                <h2>Уровень сложности</h2>
                <div>
                    <input :disabled="gameActive" v-model="level" type="radio" value="1500" name="option" id="easy" />
                    <label for="easy">Легкий</label>
                </div>
                <div>
                    <input :disabled="gameActive" v-model="level" type="radio" value="1000" name="option" id="normal" />
                    <label for="normal">Нормальный</label>
                </div>
                <div>
                    <input :disabled="gameActive" v-model="level" type="radio" value="400" name="option" id="hard" />
                    <label for="hard">Сложный</label>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    export default {
        name: "App",
        data() {
            return {
                level: 1500,
                colors: ["blue", "red", "green", "yellow"],
                round: 0,
                playerResult: [],
                currentGame: [],
                activeColor: "",
                gameActive: false,
            };
        },
        watch: {
            level() {
                this.currentGame = [];
                this.playerResult = [];
                this.round = 0;
            },
            playerResult() {
                for (let i in this.playerResult) {
                    if (this.playerResult[i] != this.currentGame[i]) {
                        this.currentGame = [];
                        this.playerResult = [];
                        this.round = 0;
                    }
                }
            },
        },
        methods: {
            setColor(index) {
                this.playerResult.push(index);
                new Audio(require(`./assets/sounds/${index}.mp3`)).play();
                if (this.playerResult.length == this.currentGame.length) {
                    this.startGame();
                }
            },
            startGame() {
                let v = this;
                v.playerResult = [];
                v.gameActive = true;
                v.round += 1;
                v.currentGame = [];
                for (let i = 0; i < v.round; i++) {
                    v.currentGame.push(Math.floor(Math.random() * (3 - 0 + 1)) + 0);
                }
                let currentIndex = 0;
                setTimeout(function tick() {
                    if (currentIndex != v.currentGame.length) {
                        v.activeColor = v.currentGame[currentIndex];
                        new Audio(require(`./assets/sounds/${v.activeColor}.mp3`)).play();
                        if (v.currentGame[currentIndex] == v.currentGame[currentIndex + 1]) {
                            setTimeout(() => {
                                v.activeColor = "";
                            }, v.level - 100);
                        }
                        currentIndex += 1;
                        setTimeout(tick, v.level);
                    } else {
                        v.activeColor = "";
                        v.gameActive = false;
                    }
                }, v.level);
            },
        },
    };
</script>

<style lang="sass">
    .container
        max-width: 600px
        margin: 0 auto
        .title
            text-align: center
        .btn-start
            background: #78BCFF
            box-sizing: border-box
            font-size: 1.4em
            border-radius: 10px
            background: #6DABE8
            border: none
            padding: 0.3em 0.6em
            cursor: pointer
            &:hover
                background: #78BCFF
        .circle
            background: #fff
            position: relative
            float: left
            margin-right: 3em
            width: 295px
            height: 290px
            border-radius: 150px
            box-shadow: 2px 1px 12px #aaa;
            .blue, .red, .yellow, .green
                position: absolute
                width: 296px
                height: 290px
                border-radius: 150px
                cursor: pointer
                opacity: 0.5
                &:focus
                    outline: none
                &:active
                    opacity: 1

                &.active
                    opacity: 1

                &.red
                    right: 0
                    background: red
                    clip: rect(0px, 300px, 150px, 150px)
                &.green
                    right: 0
                    background: green
                    clip: rect(150px,300px, 300px, 150px)
                &.yellow
                    left: 0
                    background: yellow
                    clip: rect(150px, 150px, 300px, 0px)
                &.blue
                    left: 0
                    background: blue;
                    clip: rect(0px, 150px, 150px, 0px);
</style>
