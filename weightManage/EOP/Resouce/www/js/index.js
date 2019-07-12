/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
initialize: function() {
    document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    

    // (type, url, title, content, image, success, error)
    let shareBtn = document.getElementById('shareBtn');
    shareBtn.onclick = function(){
        xy.share(3, 'http://www.baidu.com', '测试分享', '测试内容', 'http://a.b.c/xf.jpg', function(result){

        }, function(result){

        });
    }
    
    let zhendongBtn = document.getElementById('zhendong');
    zhendongBtn.onclick = function(){
        xy.vibrate('1000');
    }
    
    let lanaguageBtn = document.getElementById('lanaguage');
    lanaguageBtn.onclick = function(){
        xy.getPreferredLanguage(onSuccess, onError);
        function onSuccess(lang) {
            alert('语言：' + lang.value);
            console.info(lang);
        }
        function onError() {
            alert('获取语言失败');
        }
    }
    
    let gototabBtn = document.getElementById('gototab');
    gototabBtn.onclick = function(){
        xy.gototab(0,onSuccess, onError);
        function onSuccess() {

        }
        function onError() {

        }
    }

    let getLoginUserInfoBtn = document.getElementById('getLoginUserInfo');
    getLoginUserInfoBtn.onclick = function(){
        xy.getLoginUserInfoAgain (onSuccess,onError);
        function onSuccess(value) {
            alert(value);
        }
        function onError() {

        }
    }
    
    let playSoundBtn = document.getElementById('playSound');
    playSoundBtn.onclick = function(){
        xy.playSound ();
    }

    let logoutBtn = document.getElementById('logout');
    logoutBtn.onclick = function(){
        xy.logout ();
    }
    
    let openWindowBtn = document.getElementById('openWindow');
    openWindowBtn.onclick = function(){
        xy.openWindow('http://www.baidu.com');
    }

    let closeWindowBtn = document.getElementById('closeWindow');
    closeWindowBtn.onclick = function(){
        xy.closeWindow();
    }

    let showTabBtn = document.getElementById('showTab');
    showTabBtn.onclick = function(){
        xy.isHideTab ('1');
    }

    let hideTabBtn = document.getElementById('hideTab');
    hideTabBtn.onclick = function(){
        xy.isHideTab ('0');
    }

    let writeHealthDataBtn = document.getElementById('writeHealthData');
    writeHealthDataBtn.onclick = function(){
        //type: 0:总脂肪  1:碳水化合物  2:蛋白质
        //count: 数值
        xy.writeHealthDataToPhone ('2','18080809',onSuccess,onError);
        function onSuccess() {
            alert('写入成功');
        }
        function onError() {
            alert('写入失败');
        }
    }

    
},
    
    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
onDeviceReady: function() {
    this.receivedEvent('deviceready');
},
    
    // Update DOM on a Received Event
receivedEvent: function(id) {
    var parentElement = document.getElementById(id);
    var listeningElement = parentElement.querySelector('.listening');
    var receivedElement = parentElement.querySelector('.received');
    
    listeningElement.setAttribute('style', 'display:none;');
    receivedElement.setAttribute('style', 'display:block;');
    
    console.log('Received Event: ' + id);
}
};

app.initialize();

var eoopWeb = {
    setBPM2UnReadNum: function(BPM2UnReadValue) {
        console.log(`BPM2UnReadValue的个数是 ${BPM2UnReadValue}`);
    },
    setUnReadNum: function(BPMUnReadValue, SalesUnReadValue) {
        console.log(`BPMUnReadValue是${BPMUnReadValue}, SalesUnReadValue是${SalesUnReadValue}`);
    }
}
