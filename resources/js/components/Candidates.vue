<template>

  <div>
    <div class="p-10">
      <h1 class="text-4xl font-bold">Candidates</h1>
      <div v-if="coins"><div class="coins-container fixed top-0 left-1/2 transform -translate-x-1/2 p-4 z-10"><h1 class="text-4xl font-bold">Coins: {{ coins }}</h1></div>
      </div></div>
    <div class="p-10 grid grid-cols-1 sm:grid-cols-1 md:grid-cols-3 lg:grid-cols-3 xl:grid-cols-3 gap-5">
      <div v-for="candidate in candidates" :key="candidate.id" :class="{ 'hidden': shouldHideCandidate(candidate) }">
        <img alt="" class="w-full" src="/avatar.png">
        <div class="px-6 py-4">
          <div class="font-bold text-xl mb-2">{{ candidate.name }}</div>
          <p class="text-gray-700 text-base">{{ candidate.description }}</p>

        </div>
        <div class="px-6 pt-4 pb-2">
           <span v-for="strength in JSON.parse(candidate.strengths)"
                 :class="['inline-block rounded-full px-3 py-1 text-sm font-semibold text-gray-700 mr-2 mb-2 cursor-pointer', { 'bg-custom-green': desiredStrengths.includes(strength), 'bg-gray-200 hover:bg-gray-300': !desiredStrengths.includes(strength) }]"
                 @click="toggleStrength(strength)"
           >{{ strength }}</span>
        </div>
        <div class="px-6 pb-2">
         <span v-for="skill in JSON.parse(candidate.soft_skills)"
               :class="['inline-block rounded-full px-3 py-1 text-sm font-semibold text-gray-700 mr-2 mb-2 cursor-pointer', { 'bg-custom-green': desiredSkills.includes(skill), 'bg-gray-200 hover:bg-gray-300': !desiredSkills.includes(skill) }]"
               @click="toggleSkill(skill)"
         >{{ skill }}</span>
        </div>
        <div class="p-6 float-right">
          <button
              class="bg-white hover:bg-gray-100 text-gray-800 font-semibold py-2 px-4 border border-gray-400 rounded shadow"
              @click="contactCandidate(candidate.id)"
          >Contact</button>
          <button
              class="bg-white hover:bg-gray-100 text-gray-800 font-semibold py-2 px-4 border border-gray-400 hover:bg-teal-100 rounded shadow"
              @click="hireCandidate(candidate.id)"
          >Hire</button>
        </div>
      </div>
    </div>
    <MvpCandidates />
  </div>
</template>

<script>
import axios from 'axios';
import MvpCandidates from './MvpCandidates.vue';
import Swal from 'sweetalert2';



export default {
  name: 'CandidateList',
  props: {
    candidates: Array,
    initialCoins: Number, // Added prop for initial coins value
    // coins: Number,
  },
  components: {
    MvpCandidates,
  },



  data() {
    return {
      desiredStrengths: ['PHP'],
      desiredSkills: ['Diplomacy', 'Leadership'],
      coins: 0,
      //  coins: this.coins // Initialize coins with the prop value
    };
  },
  mounted() {

    this.fetchCoins(); // Fetch coins when the component is mounted


  },
  methods: {
    hireCandidate(candidateId) {
      axios.post(`/candidates-hire/${candidateId}`)
          .then(response => {
            const message = response.data.message;
            const coins = response.data.coins; // Assuming 'coins' is returned from the server
            this.showNotification(message);          // Display success message
            this.coins = coins; // Update coins in the component

          })
          .catch(error => {
            console.error('Error hiring candidate:', error);
            this.toast.error('An error occurred while hiring the candidate.');

          });
    },
    contactCandidate(candidateId) {
      axios.post(`/candidates-contact/${candidateId}`)
          .then(response => {
            const message = response.data.message;
            const coins = response.data.coins; // Assuming 'coins' is returned from the server

            this.showNotification(message);
            this.coins = coins; // Update coins in the component

            // No need to reload the window
          });
    },
    shouldHideCandidate(candidate) {
      if (this.desiredStrengths.length === 0) {
        return false; // Show all candidates if no strengths are selected
      }
      const candidateStrengths = JSON.parse(candidate.strengths);
      return !this.desiredStrengths.every(strength => candidateStrengths.includes(strength));

      // Check if the candidate has the "WordPress" skill
      // return JSON.parse(candidate.strengths).includes('Wordpress');
    },



    fetchCoins() {
      axios.get('/coins')
          .then(response => {
            console.log(response.data); // Log the response data to verify the format
            this.coins = response.data.coins; // Update coins value in the component
          })
          .catch(error => {
            console.error('Error fetching coins:', error);
            // Handle error
          });
    },

    toggleStrength(strength) {
      const index = this.desiredStrengths.indexOf(strength);
      if (index === -1) {
        this.desiredStrengths.push(strength);
      } else {
        this.desiredStrengths.splice(index, 1);
      }
    },

    toggleSkill(skill) {
      const index = this.desiredSkills.indexOf(skill);
      if (index === -1) {
        this.desiredSkills.push(skill);
      } else {
        this.desiredSkills.splice(index, 1);
      }
    },
    showNotification(message) {
      Swal.fire({
        title: message,
        toast: true,
        position: 'bottom-end',
        showConfirmButton: false,
        timer: 3000 // Display duration in milliseconds
      });
    },




  },
}
</script>

<style>
.cursor-pointer {
  cursor: pointer;
}
.bg-custom-green {
  background-color: #32CD32;
}
</style>
