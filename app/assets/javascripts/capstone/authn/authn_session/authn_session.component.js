(function() {
  "use strict";

  angular
    .module("capstone.authn")
    .component("capAuthnSession", {
      templateUrl: templateUrl,
      controller: AuthnSessionController
    });


  templateUrl.$inject = ["capstone.config.APP_CONFIG"];
  function templateUrl(APP_CONFIG) {
    return APP_CONFIG.authn_session_html;
  }    

  AuthnSessionController.$inject = ["$scope", "capstone.authn.Authn", "capstone.authn.whoAmI"];
  function AuthnSessionController($scope, Authn, whoAmI) {
    var vm=this;
    vm.loginForm = {}
    vm.login = login;
    vm.logout = logout;
    vm.getCurrentUser = Authn.getCurrentUser;
    vm.getCurrentUserName = Authn.getCurrentUserName;
    // vm.getCurrentUserImageUrl = whoAmI.

    vm.$onInit = function() {
      console.log("AuthnSessionController",$scope);
        vm.whoAmI = null;
        whoAmI.get().$promise.then(
          function(value){ vm.whoAmI = value; },
          function(value){ vm.whoAmI = value; }
        );
      
    }

    vm.$postLink = function() {
      vm.dropdown = $("#login-dropdown")
    }
    return;
    //////////////
    function login() {
      console.log("login");
      $scope.login_form.$setPristine();
      vm.loginForm["errors"] = null;
      Authn.login(vm.loginForm).then(
        function(){
          vm.dropdown.removeClass("open");
        },
        function(response){
          vm.loginForm["errors"] = response.errors;
        });
    }

    function logout() {
      Authn.logout().then(
        function(){
          vm.dropdown.removeClass("open");
        });
    }
  }
})(); 